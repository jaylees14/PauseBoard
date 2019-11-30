//
//  Key.swift
//  KitKat
//
//  Created by Jay Lees on 13/11/2019.
//  Copyright © 2019 Team Macro. All rights reserved.
//

import Foundation

// Key -> Mac Key Code
enum Key: Int, CaseIterable {
    case leftArrow = 123
    case rightArrow = 124
    case upArrow = 126
    case downArrow = 125
    
    var name: String {
        switch self {
        case .leftArrow: return "L"
        case .rightArrow: return "R"
        case .downArrow: return "D"
        case .upArrow: return "U"
        }
    }
}

// Byte Received -> Key
let keyMapping: [UInt8: Key] = [
    1: .leftArrow,
    2: .rightArrow,
    3: .upArrow,
    4: .downArrow
]
