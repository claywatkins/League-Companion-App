//
//  mmrTypes.swift
//  League Companion App
//
//  Created by Clayton Watkins on 5/2/21.
//

import Foundation

struct MMR: Codable {
    var ranked: ranked
    var normal: normal
}

struct Ranked: Codable {
    var avg: Int?
    var timestamp: Int?
}
 
struct Normal: Codable {
    var avg: Int?
    var timestamp: Int?
}
