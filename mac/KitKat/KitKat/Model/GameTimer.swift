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
    @Published public var currentTimeSeconds: Double
    private let gameTime: Double
    private var timer: Timer?
    
    public init(gameTime: Double) {
        self.gameTime = gameTime
        self.currentTimeSeconds = gameTime
    }
    
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
        currentTimeSeconds = gameTime
        timer?.invalidate()
        isTimerRunning = false
    }
    
    public func getCurrentTime() -> String {
        let hours = String(format: "%02d", currentTimeSeconds / 3600)
        let minutes = String(format: "%02d", Int((currentTimeSeconds.truncatingRemainder(dividingBy: 3600.0) / 60)))
        let seconds = String(format: "%02d", Int((currentTimeSeconds.truncatingRemainder(dividingBy: 3600.0)).truncatingRemainder(dividingBy: 60)))
        return "\(hours):\(minutes).\(seconds)"
    }
}
