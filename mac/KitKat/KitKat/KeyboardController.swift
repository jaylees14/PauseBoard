//
//  KeyboardController.swift
//  KitKat
//
//  Created by Jay Lees on 08/11/2019.
//  Copyright © 2019 Team Macro. All rights reserved.
//

import Foundation
import ORSSerial

class KeyboardController: NSObject, ObservableObject {
    public enum State: CustomDebugStringConvertible {
        case connectedToKeyboard(name: String)
        case notConnected
        
        var debugDescription: String {
            switch self {
            case .connectedToKeyboard(let name):
                return "Connected to keyboard \(name)"
            case .notConnected:
                return "Not connected"
            }
        }
    }
    
    @Published var shiftModifier = false
    @Published var keyPress: String? 
    @Published var state = KeyboardController.State.notConnected
    @Published var shouldShowError = false
    @Published var error: Error? {
        didSet {
            shouldShowError = error != nil
        }
    }
    private var readBytes = [UInt8]()
    private var serialPort: ORSSerialPort?
    
    override init() {
        super.init()
        serialPort = ORSSerialPortManager.shared().availablePorts.filter { $0.name.contains("usbmodem") }.first
        serialPort?.delegate = self
        serialPort?.open()
        serialPort?.baudRate = 9600
    }
    
    func sendData(percentage: UInt8) -> Bool {
        return serialPort?.send(Data(repeating: percentage, count: 1)) ?? false
    }
}

extension KeyboardController: ORSSerialPortDelegate {
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        // First byte: which modifier is pressed - 127 if nothing, 128 if shift
        // Second byte: which key is pressed - 1 -> 255
        // Third byte: null byte
        for item in data {
            if item == 0 {
                if readBytes.count >= 2 {
                    shiftModifier = readBytes[0] == 129
                    print(readBytes[1])
                    keyPress = String(data: Data([readBytes[1]]), encoding: .ascii)
                }
                readBytes.removeAll()
            } else {
                readBytes.append(item)
            }
        }
    }
    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        self.state = .connectedToKeyboard(name: serialPort.name)
    }
    
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        self.state = .notConnected
    }
       
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        self.error = error
    }
    
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        self.serialPort = nil
    }
}
