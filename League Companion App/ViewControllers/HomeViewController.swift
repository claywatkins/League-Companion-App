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
    }
    
    // MARK: - IBAction
    @IBAction func searchButtonTapped(_ sender: Any) {
        guard let summonerName = summonerNameTextField.text, !summonerName.isEmpty else { return }
        networkController.getMMR(summonerName: summonerName) { result in
            do {
                let returnedMMR = try result.get()
                DispatchQueue.main.async {
                    if let rankedMMR = returnedMMR.ranked.avg {
                        self.rankedMMRLabel.text = "\(rankedMMR)"
                    } else {
                        self.rankedMMRLabel.text = "No MMR Found"
                    }
                    if let normalMMR = returnedMMR.normal.avg {
                        self.normalMMRLabel.text = "\(normalMMR)"
                    } else {
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
