//
//  mmrTypes.swift
//  League Companion App
//
//  Created by Clayton Watkins on 5/2/21.
//

import Foundation

struct MMR: Codable {
    var ranked: Ranked
    var normal: Normal
}

struct Ranked: Codable {
    var avg: Int?
    var timestamp: Double?
    var historical: [Historical]?
}
 
struct Normal: Codable {
    var avg: Int?
    var timestamp: Double?
    var historical: [Historical]?
}

struct Historical: Codable {
    var avg: Int?
    var timestamp: Double?
}
