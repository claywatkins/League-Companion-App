//
//  mmrTypes.swift
//  League Companion App
//
//  Created by Clayton Watkins on 5/2/21.
//

import Foundation

struct mmr: Codable {
    var ranked: ranked
    var normal: normal
}

struct ranked: Codable {
    var avg: Int?
    var timestamp: Int?
}
 
struct normal: Codable {
    var avg: Int?
    var timestamp: Int?
}
