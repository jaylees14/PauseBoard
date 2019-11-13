//
//  ContentView.swift
//  KitKat
//
//  Created by Jay Lees on 06/11/2019.
//  Copyright © 2019 Team Macro. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject public var keyboardController: KeyboardController

    var body: some View {
        VStack {
            Text("Key Received: \(keyboardController.shiftModifier ? "⇧" : "")\(keyboardController.keyPress ?? "")")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text("State: \(keyboardController.state.debugDescription)")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .alert(isPresented: $keyboardController.shouldShowError, content: {
            Alert(title: Text("Something went wrong"), message: Text(keyboardController.error.debugDescription))
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(KeyboardController())
    }
}
