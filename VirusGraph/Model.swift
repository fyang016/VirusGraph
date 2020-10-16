//
//  Model.swift
//  VirusGraph
//
//  Created by AdrenResi on 10/13/20.
//

import Foundation

struct Model: Codable {
    var secondsSinceEpoch: Int
    var tested: Int
    var positive: Int
    var deaths: Int
}
