//
//  Keyboard.swift
//  KitKat
//
//  Created by Jay Lees on 13/11/2019.
//  Copyright © 2019 Team Macro. All rights reserved.
//

import Foundation

class Keyboard: ObservableObject {
    @Published var shiftModifier = false
    @Published var state = KeyboardController.State.disconnected
    @Published var keyPressed: String?
    @Published var shouldShowError = false
    @Published var error: Error? {
        didSet {
            shouldShowError = true
        }
    }
}
