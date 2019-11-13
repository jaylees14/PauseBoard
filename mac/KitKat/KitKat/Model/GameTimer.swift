//
//  GameTimer.swift
//  KitKat
//
//  Created by Jay Lees on 13/11/2019.
//  Copyright © 2019 Team Macro. All rights reserved.
//

import Foundation

class GameTimer: ObservableObject {
    @Published private(set) var isTimerRunning = false
    @Published public var currentTimeSeconds = 120
    private var timer: Timer?
    
    public func start() {
        isTimerRunning = true
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard self?.currentTimeSeconds ?? 0 > 0 else {
                self?.timer?.invalidate()
                self?.isTimerRunning = false
                return
            }
            self?.currentTimeSeconds -= 1
        }
    }

    public func pause() {
        timer?.invalidate()
        isTimerRunning = false
    }
    
    public func reset() {
        currentTimeSeconds = 120
        timer?.invalidate()
        isTimerRunning = false
    }
    
    public func getCurrentTime() -> String {
        let hours = String(format: "%02d", currentTimeSeconds / 3600)
        let minutes = String(format: "%02d", (currentTimeSeconds % 3600) / 60)
        let seconds = String(format: "%02d", (currentTimeSeconds % 3600) % 60)
        return "\(hours):\(minutes).\(seconds)"
    }
}
