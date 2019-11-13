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
    private var keyboardController: KeyboardController {
        let controller = KeyboardController()
        controller.delegate = self
        return controller
    }
    
    @State var keyboard = Keyboard()
    @ObservedObject var gameTimer = GameTimer()
    
    var body: some View {
        VStack {
            Text("\(gameTimer.getCurrentTime())").font(.headline)
            HStack {
                Button(action: {
                    self.gameTimer.isTimerRunning ? self.gameTimer.pause() : self.gameTimer.start()
                }, label: {
                    Text(gameTimer.isTimerRunning ? "Pause" : "Start")
                })
                Button(action: {
                    self.gameTimer.reset()
                }, label: {
                    Text("Reset")
                })
            }
            Text("Key Received: \(keyboard.shiftModifier ? "⇧" : "")\(keyboard.keyPressed ?? "")")
            Text("State: \(keyboard.state.debugDescription)")
        }
        .padding()
        .alert(isPresented: $keyboard.shouldShowError, content: {
            Alert(title: Text("Something went wrong"), message: Text(keyboard.error.debugDescription))
        })
        .onReceive(gameTimer.objectWillChange) { (publisher) in
            if self.gameTimer.currentTimeSeconds < 30 && self.gameTimer.isTimerRunning {
                // Linearly increase
                let percentage = (30.0 - Double(self.gameTimer.currentTimeSeconds)) / 30.0 * 100.0
                print(percentage)
                self.keyboardController.sendData(percentage: UInt8(percentage))
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
