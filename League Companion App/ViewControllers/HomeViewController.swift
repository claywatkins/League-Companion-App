//
//  HomeViewController.swift
//  League Companion App
//
//  Created by Clayton Watkins on 5/2/21.
//

import UIKit
import Charts

class HomeViewController: UIViewController, ChartViewDelegate {
    // MARK: - IBOutlet
    @IBOutlet weak var mmrDataView: UIView!
    @IBOutlet weak var rankedGraphView: UIView!
    @IBOutlet weak var normalGraphView: UIView!
    @IBOutlet weak var dateSourcedLabel: UILabel!
    @IBOutlet weak var rankedMMRLabel: UILabel!
    @IBOutlet weak var rankedMMRActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var normalMMRLabel: UILabel!
    @IBOutlet weak var normalMMRActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var summonerNameTextField: UITextField!
    @IBOutlet weak var rankedHistoryGraph: LineChartView!
    @IBOutlet weak var normalHistoryGraph: LineChartView!
    
    // MARK: - Properties
    var networkController = NetworkController.shared
    var dataController = DataController.shared
    let df = DateFormatter()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        hideUIElements()
        df.dateFormat = "MMMM dd,yyyy"
        rankedHistoryGraph.delegate = self
        normalHistoryGraph.delegate = self
    }
    
    // MARK: - Methods
    private func hideUIElements() {
        mmrDataView.alpha = 0
        rankedGraphView.alpha = 0
        normalGraphView.alpha = 0
        rankedMMRLabel.isHidden = true
        rankedMMRActivityIndicator.isHidden = true
        normalMMRLabel.isHidden = true
        normalMMRActivityIndicator.isHidden = true
        dateSourcedLabel.isHidden = true
    }
    
    private func fadeInViews() {
        let views = [mmrDataView, rankedGraphView, normalGraphView]
        var delayCounter = 0
        for view in views{
            UIView.animate(withDuration: 1.25, delay: Double(delayCounter) * 0.5, options: .curveEaseInOut, animations: {
                view!.alpha = 1
            }, completion: nil)
            delayCounter += 1
        }
    }
    
    private func updateCharts() {
        let rankedHistory = dataController.rankedHistory
        let normalHistory = dataController.normalHistory
        if dataController.normalHistory.count != 0 {
            var lineChartDataEntry:[ChartDataEntry] = []
            for i in dataController.normalHistory.indices {
                let value = ChartDataEntry(x: normalHistory[i].timestamp!, y: Double(normalHistory[i].avg!))
                lineChartDataEntry.append(value)
            }
            let set = LineChartDataSet(entries: lineChartDataEntry)
            set.colors = ChartColorTemplates.joyful()
            let data = LineChartData(dataSet: set)
            normalHistoryGraph.data = data
        }
    }
    
    // MARK: - IBAction
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let summonerName = summonerNameTextField.text, !summonerName.isEmpty else { return }
        rankedMMRLabel.text = ""
        normalMMRLabel.text = ""
        fadeInViews()
        rankedMMRActivityIndicator.isHidden = false
        rankedMMRActivityIndicator.startAnimating()
        normalMMRActivityIndicator.isHidden = false
        normalMMRActivityIndicator.startAnimating()
        networkController.getMMR(summonerName: summonerName) { [weak self] result in
            do {
                let returnedMMR = try result.get()
                let timeInterval = TimeInterval(returnedMMR.normal.timestamp!)
                let date = Date(timeIntervalSince1970: timeInterval)
                if let rankedHistory = returnedMMR.ranked.historical {
                    for data in rankedHistory {
                        self?.dataController.rankedHistory.append(data)
                        print(self?.dataController.rankedHistory.count)
                    }
                }
                if let normalHistory = returnedMMR.normal.historical {
                    for data in normalHistory {
                        self?.dataController.normalHistory.append(data)
                        print(self?.dataController.rankedHistory.count)
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    self?.rankedMMRActivityIndicator.stopAnimating()
                    self?.rankedMMRActivityIndicator.isHidden = true
                    self?.normalMMRActivityIndicator.stopAnimating()
                    self?.normalMMRActivityIndicator.isHidden = true
                    self?.updateCharts()
                    if let rankedMMR = returnedMMR.ranked.avg {
                        self?.rankedMMRLabel.isHidden = false
                        self?.rankedMMRLabel.text = "\(rankedMMR)"
                    } else {
                        self?.rankedMMRLabel.isHidden = false
                        self?.rankedMMRLabel.text = "No MMR Found"
                    }
                    if let normalMMR = returnedMMR.normal.avg {
                        self?.dateSourcedLabel.isHidden = false
                        self?.dateSourcedLabel.text = "Data from \(self?.df.string(from: date) ?? "")"
                        self?.normalMMRLabel.isHidden = false
                        self?.normalMMRLabel.text = "\(normalMMR)"
                    } else {
                        self?.normalMMRLabel.isHidden = false
                        self?.rankedMMRLabel.text = "No MMR Found"
                    }
                    
                }
            } catch {
                print("Error getting returned data: \(error)")
            }
        }
    }
    
}

// MARK: - Extension
extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0.0
    }
}
