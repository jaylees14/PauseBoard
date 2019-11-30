//
//  Logger.swift
//  KitKat
//
//  Created by Jay Lees on 13/11/2019.
//  Copyright © 2019 Team Macro. All rights reserved.
//

import Foundation


class Logger {
    public static let instance = Logger()
    private var logItems = [Loggable]()
    
    public func log(_ item: Loggable) {
        print(item)
        logItems.append(item)
    }
    
    public func exportLogs(to filename: String) {
        do {
            let folder = FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Desktop").appendingPathComponent("logs")
            
            var isDir: ObjCBool = false
            let fileExists = FileManager.default.fileExists(atPath: folder.path, isDirectory: &isDir)
            
            if !isDir.boolValue || !fileExists {
                 try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
            }

            let encoded = try JSONEncoder().encode(logItems)
            let filepath = folder.appendingPathComponent(filename)
            FileManager.default.createFile(atPath: filepath.path, contents: nil, attributes: nil)
            try encoded.write(to: filepath)
            
            print("Saved logs to \(filepath.path)")
            logItems.removeAll()
        } catch (let error) {
            print("ERROR: \(error)")
        }
    }
}
