//
//  ContentView.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/03/09.
//

import ARKit
import Combine
import DiceContent
import RealityKit
import simd
import SwiftUI

struct ContentView: View {

    @State private var diceEntity = Entity()
    @State private var enlarge = false
    @State private var sceneUpdateSubscription : Cancellable? = nil
    @StateObject private var viewModel: ContentViewModel = ContentViewModel()

    var body: some View {
        VStack {
            RealityView { content in
                await viewModel.onMakeRealityView()
                // Called per every frame
                sceneUpdateSubscription = content.subscribe(to: SceneEvents.Update.self) { event in
                    viewModel.onUpdateSceneEvents()
                } as? any Cancellable
                
                // Add the initial RealityKit content
                if let diceEntity = try? await Entity(named: "Scene", in: diceContentBundle) {
                    self.diceEntity = diceEntity
                    content.add(diceEntity)
                    diceEntity.position = viewModel.entityInitialPosition
                }
            } update: { content in
                // Update the RealityKit content when SwiftUI state changes
                if let lookParam = viewModel.model.look {
                    diceEntity.look(at: lookParam.at, from: lookParam.from, relativeTo: nil)
                }
                diceEntity.transform.scale = viewModel.model.diceEnlargeStrategy.scale
            }
            .gesture(TapGesture().targetedToAnyEntity().onEnded { _ in
                viewModel.onTapDiceEntity()
            })

            VStack {
                Toggle(
                    "Enlarge RealityView Content", 
                    isOn: .init(
                        get: { viewModel.model.diceEnlargeStrategy.isOnEnlargement },
                        set: { isOn in viewModel.onToggleTapped(isOn) }
                    )
                )
                    .toggleStyle(.button)
            }.padding().glassBackgroundEffect()
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
