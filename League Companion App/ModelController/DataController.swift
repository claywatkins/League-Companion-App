//
//  DataController.swift
//  League Companion App
//
//  Created by Clayton Watkins on 5/2/21.
//

import Foundation

class DataController {
    // MARK: - Properties
    static let shared = DataController()
    var rankedHistory: [Historical] = []
    var normalHistory: [Historical] = []
}
