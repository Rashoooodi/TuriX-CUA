//
//  ContentView.swift
//  TuriXMacApp
//
//  Created by TuriX Team
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if appState.setupCompleted {
                MainChatView()
            } else {
                SetupFlowView()
            }
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
    }
}
