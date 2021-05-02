//
//  NetworkController.swift
//  League Companion App
//
//  Created by Clayton Watkins on 5/2/21.
//

import Foundation

enum NetworkError: Error {
    case noData
    case badDecode
    case tryAgain
}

class NetworkController {
    static let shared = NetworkController()
    let baseURL = URL(string: "https://na.whatismymmr.com/api/v1/summoner?name=")
    
    func getMMR(summonerName: String, completion: @escaping (Result<mmr, NetworkError>) -> Void) {
        
    }
}
