//
//  AppDelegate.swift
//  KitKat
//
//  Created by Jay Lees on 06/11/2019.
//  Copyright © 2019 Team Macro. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    let popover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        popover.contentViewController = NSHostingController(rootView: ContentView())
        popover.behavior = .transient
        
        if let button = statusItem.button {
            button.image = NSImage(named: NSImage.Name("StatusBarIcon"))
            button.action = #selector(onStatusBarButtonClick(_:))
        }
    }
    
    @objc func onStatusBarButtonClick(_ sender: Any?) {
        guard let button = statusItem.button else {
            return
        }
        
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }
}
