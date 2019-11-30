//
//  ContentView.swift
//  KitKat
//
//  Created by Jay Lees on 06/11/2019.
//  Copyright © 2019 Team Macro. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    private static let gameTime = 45.0
    private static let resistanceIncreaseTime = 30.0
    private var keyboardController = KeyboardController()
    @State private var currentUser = 0
    
    @ObservedObject var keyboard = Keyboard()
    @ObservedObject var gameTimer = GameTimer(gameTime: gameTime)

    init(){
        keyboardController.delegate = self
    }
    
    var body: some View {
        VStack {
            Text("\(gameTimer.getCurrentTime())").font(.largeTitle).frame(width: 200, height: 20, alignment: .center)
            HStack {
                Button(action: {
                    self.gameTimer.isTimerRunning ? self.gameTimer.pause() : self.gameTimer.start()
                }, label: {
                    Text(gameTimer.isTimerRunning ? "Pause" : "Start")
                }).disabled(gameTimer.currentTimeSeconds == 0)
                
                Button(action: {
                    self.gameTimer.reset()
                    self.currentUser = self.currentUser + 1
                    self.keyboardController.sendData(percentage: 0)
                }, label: {
                    Text("Reset")
                })
            }
            Text("State: \(keyboard.state.debugDescription)").multilineTextAlignment(.center)
        }
        .padding(.all, 30)
        .alert(isPresented: $keyboard.shouldShowError, content: {
            Alert(title: Text("Something went wrong"), message: Text(keyboard.error.debugDescription))
        })
        .onReceive(gameTimer.objectWillChange) { (publisher) in
            if self.gameTimer.currentTimeSeconds < ContentView.resistanceIncreaseTime && self.gameTimer.isTimerRunning {
                // Linearly increase
                let percentage = (ContentView.resistanceIncreaseTime - self.gameTimer.currentTimeSeconds) / ContentView.resistanceIncreaseTime * 100.0
                self.keyboardController.sendData(percentage: UInt8(percentage))
            }
            
            if self.gameTimer.currentTimeSeconds == 0 && self.gameTimer.isTimerRunning {
                Logger.instance.exportLogs(to: "\(self.currentUser)-results.json")
                NotificationManager.sendNotification(title: "Time's up!", message: "Please stop playing!")
            }
        }
    }
    
}

extension ContentView: KeyboardControllerDelegate {
    func didChangeState(to state: KeyboardController.State) {
        self.keyboard.state = state
    }
    
    func didReceiveKey(data: UInt8, shift: Bool) {
        self.keyboard.shiftModifier = shift
        self.keyboard.keyPressed = String(data: Data(repeating: data, count: 1), encoding: .ascii)
        // Forward key press to OS
        if let key = keyMapping[data] {
            KeyForwarder.pressKey(key)
        }
    }
    
    func didReceiveError(_ error: Error) {
        self.keyboard.error = error
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
