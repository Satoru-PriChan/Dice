//
//  ContentView.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/03/09.
//

import SwiftUI
import RealityKit
import DiceContent

struct ContentView: View {

    @State var enlarge = false

    var body: some View {
        VStack {
            RealityView { content in
                // Add the initial RealityKit content
                if let scene = try? await Entity(named: "Scene", in: diceContentBundle) {
                    content.add(scene)
                }
            } update: { content in
                // Update the RealityKit content when SwiftUI state changes
                if let scene = content.entities.first {
                    let uniformScale: Float = enlarge ? 1.4 : 1.0
                    scene.transform.scale = [uniformScale, uniformScale, uniformScale]
                }
            }
            .gesture(TapGesture().targetedToAnyEntity().onEnded { _ in
                enlarge.toggle()
            })

            VStack {
                Toggle("Enlarge RealityView Content", isOn: $enlarge)
                    .toggleStyle(.button)
            }.padding().glassBackgroundEffect()
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
