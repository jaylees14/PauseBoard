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
    case leftArrow = 0
    case rightArrow = 1
    case upArrow = 2
    case downArrow = 13
}

// Byte Received -> Key
let keyMapping: [UInt8: Key] = [
    1: .leftArrow,
    2: .rightArrow,
    3: .upArrow,
    4: .downArrow
]
