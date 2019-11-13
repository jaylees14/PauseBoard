//
//  KeyboardController.swift
//  KitKat
//
//  Created by Jay Lees on 08/11/2019.
//  Copyright © 2019 Team Macro. All rights reserved.
//

import Foundation
import ORSSerial

protocol KeyboardControllerDelegate {
    func didChangeState(to state: KeyboardController.State)
    func didReceiveKey(key: UInt8, shift: Bool)
    func didReceiveError(_ error: Error)
}

class KeyboardController: NSObject {
    public enum State: CustomDebugStringConvertible {
        case connectedToKeyboard(name: String)
        case disconnected
        
        var debugDescription: String {
            switch self {
            case .connectedToKeyboard(let name):
                return "Connected to keyboard \(name)"
            case .disconnected:
                return "Disconnected"
            }
        }
    }
    
    public var delegate: KeyboardControllerDelegate?
    private var readBytes = [UInt8]()
    private var serialPort: ORSSerialPort?
    
    override init() {
        super.init()
        serialPort = ORSSerialPortManager.shared().availablePorts.filter { $0.name.contains("usbmodem") }.first
        serialPort?.delegate = self
        serialPort?.open()
        serialPort?.baudRate = 9600
    }
    
    @discardableResult
    func sendData(percentage: UInt8) -> Bool {
        return serialPort?.send(Data(repeating: percentage, count: 1)) ?? false
    }
}

extension KeyboardController: ORSSerialPortDelegate {
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        // First byte: which modifier is pressed - 128 if nothing, 129 if shift
        // Second byte: which key is pressed - 1 -> 255
        // Third byte: null byte
        for item in data {
            if item == 0 {
                if readBytes.count >= 2 {
                    delegate?.didReceiveKey(key: readBytes[1], shift: readBytes[0] == 129)
                }
                readBytes.removeAll()
            } else {
                readBytes.append(item)
            }
        }
    }
    
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
        self.delegate?.didChangeState(to: .connectedToKeyboard(name: serialPort.name))
    }
    
    func serialPortWasClosed(_ serialPort: ORSSerialPort) {
        self.delegate?.didChangeState(to: .disconnected)
    }
       
    func serialPort(_ serialPort: ORSSerialPort, didEncounterError error: Error) {
        self.delegate?.didReceiveError(error)
    }
    
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
        self.serialPort = nil
    }
}
