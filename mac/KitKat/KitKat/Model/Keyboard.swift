//
//  Keyboard.swift
//  KitKat
//
//  Created by Jay Lees on 13/11/2019.
//  Copyright © 2019 Team Macro. All rights reserved.
//

import Foundation

struct Keyboard {
    var shiftModifier = false
    var state = KeyboardController.State.disconnected
    var keyPressed: String?
    var shouldShowError = false
    var error: Error? {
        didSet {
            shouldShowError = true
        }
    }
}
