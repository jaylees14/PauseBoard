//
//  NotificationManager.swift
//  KitKat
//
//  Created by Jay Lees on 30/11/2019.
//  Copyright © 2019 Team Macro. All rights reserved.
//

import Foundation
import Cocoa


class NotificationManager {
    public static func sendNotification(title: String, message: String) {
        let notification = NSUserNotification()
        notification.identifier = "\(Int.random(in: 0..<Int.max))"
        notification.title = title
        notification.informativeText = message
        NSUserNotificationCenter.default.deliver(notification)
    }
}

