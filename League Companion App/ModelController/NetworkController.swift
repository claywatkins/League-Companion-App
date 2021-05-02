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
    let baseURL = URL(string: "https://na.whatismymmr.com")!
    
    func getMMR(summonerName: String, completion: @escaping (Result<MMR, NetworkError>) -> Void) {
        
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        urlComponents.path = "/api/v1/summoner"
        urlComponents.queryItems = [
            URLQueryItem(name: "name", value: summonerName)
        ]
        let requestURL = urlComponents.url?.absoluteURL
        var request = URLRequest(url: requestURL!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
                completion(.failure(.tryAgain))
                return
            }
            
            if let response = response {
                print(response)
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let returnedMMRdata = try JSONDecoder().decode(MMR.self, from: data)
                completion(.success(returnedMMRdata))
            } catch {
                print("Error decoding MMR data: \(error)")
            }
        }
        task.resume()
    }
}
