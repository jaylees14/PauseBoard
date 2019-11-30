//
//  Loggable.swift
//  KitKat
//
//  Created by Jay Lees on 13/11/2019.
//  Copyright © 2019 Team Macro. All rights reserved.
//

import Foundation

enum Loggable {
    case keyPress(date: Date, key: String, shift: Bool)
    case resistanceIncrease(date: Date, level: UInt8)
}

extension Loggable: Encodable {
    private enum CodingKeys: String, CodingKey {
        // .keyPress
        case keyPressed
        case shiftModified
        
        // .resistanceIncrease
        case resistanceLevel
        
        // Common
        case date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch self {
        case let .keyPress(date, key, shift):
            try container.encode(ISO8601DateFormatter().string(from: date), forKey: .date)
            try container.encode(key, forKey: .keyPressed)
            try container.encode(shift, forKey: .shiftModified)
        case let .resistanceIncrease(date, level):
            try container.encode(ISO8601DateFormatter().string(from: date), forKey: .date)
            try container.encode(level, forKey: .resistanceLevel)
        }
        
    }
    
}
