//
//  DiceApp.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/03/09.
//

import SwiftUI

@main
struct DiceApp: App {
    @State var immersionStyle: ImmersionStyle = .mixed
    
    var body: some Scene {
        WindowGroup {
            Opener()
        }.windowStyle(.volumetric)
        
        ImmersiveSpace(
            id: "Dice") {
                ContentView()
        }
            .immersionStyle(
                selection: $immersionStyle, in: .mixed)
    }
}
