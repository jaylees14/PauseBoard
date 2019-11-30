//
//  KeypressForwarder.swift
//  KitKat
//
//  Created by Jay Lees on 13/11/2019.
//  Copyright © 2019 Team Macro. All rights reserved.
//

import Foundation

class KeyForwarder {
    public static func pressKey(_ key: Key) {
        Logger.instance.log(.keyPress(date: Date(), key: key.name, shift: false))
        executeScript("tell application \"System Events\"\nkey code \(key.rawValue) -- enter\nend")
    }
    
    @discardableResult
    private static func executeScript(_ script: String) -> String? {
        var error: NSDictionary?
        if let result = NSAppleScript(source: script)?.executeAndReturnError(&error) {
            return result.stringValue
        } else {
            print(error ?? "An error occurred")
        }
        return nil
    }
}
