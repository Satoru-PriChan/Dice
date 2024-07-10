//
//  DiceApp.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/03/09.
//

import SwiftUI

@main
struct DiceApp: App {
    @State private var immersionStyle: any ImmersionStyle = .mixed
    @State private var appViewModel: AppViewModel = .init()
    
    var body: some Scene {
        WindowGroup {
            //Opener()
            MenuView()
        }
            .windowStyle(.plain)
            .environmentObject(appViewModel)
        
        
        ImmersiveSpace(
            id: "Dice") {
            ImmersiveView()
        }
            .immersionStyle(
                selection: $immersionStyle, in: .mixed
            )
            .environmentObject(appViewModel)
    }
}
