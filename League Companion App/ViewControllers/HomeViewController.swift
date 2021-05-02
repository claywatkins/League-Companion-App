//
//  HomeViewController.swift
//  League Companion App
//
//  Created by Clayton Watkins on 5/2/21.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var rankedMMRLabel: UILabel!
    @IBOutlet weak var normalMMRLabel: UILabel!
    @IBOutlet weak var summonerNameTextField: UITextField!
    
    // MARK: - Properties
    var networkController = NetworkController.shared
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        rankedMMRLabel.isHidden = true
        normalMMRLabel.isHidden = true
    }
    
    // MARK: - IBAction
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let summonerName = summonerNameTextField.text, !summonerName.isEmpty else { return }
        networkController.getMMR(summonerName: summonerName) { result in
            do {
                let returnedMMR = try result.get()
                DispatchQueue.main.async {
                    if let rankedMMR = returnedMMR.ranked.avg {
                        self.rankedMMRLabel.isHidden = false
                        self.rankedMMRLabel.text = "\(rankedMMR)"
                    } else {
                        self.rankedMMRLabel.isHidden = false
                        self.rankedMMRLabel.text = "No MMR Found"
                    }
                    if let normalMMR = returnedMMR.normal.avg {
                        self.normalMMRLabel.isHidden = false
                        self.normalMMRLabel.text = "\(normalMMR)"
                    } else {
                        self.normalMMRLabel.isHidden = false
                        self.rankedMMRLabel.text = "No MMR Found"
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
