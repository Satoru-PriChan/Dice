//
//  DiceApp.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/03/09.
//

import SwiftUI

@main
struct DiceApp: App {
    @State var immersionStyle: any ImmersionStyle = .mixed
    
    var body: some Scene {
        WindowGroup {
            //Opener()
            MenuView()
        }.windowStyle(.plain)
        
        ImmersiveSpace(
            id: "Dice") {
            ImmersiveView()
        }
            .immersionStyle(
                selection: $immersionStyle, in: .mixed)
    }
}
