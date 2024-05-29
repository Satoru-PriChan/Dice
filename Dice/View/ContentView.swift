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
                    diceEntity.position = viewModel.model.position
                }
            }
            .gesture(TapGesture().targetedToEntity(diceEntity).onEnded { _ in
                viewModel.onTapDiceEntity()
            })
            .gesture(DragGesture().targetedToEntity(diceEntity).onChanged { value in
                print("drag")
                viewModel.onDragDiceEntity(
                    x: Float(value.translation3D.x),
                    y: Float(value.translation3D.y),
                    z: Float(value.translation3D.z)
                )
            })
            .gesture(RotateGesture3D().targetedToEntity(diceEntity).onChanged { value in
                print("rotate")
                viewModel.onRotateDiceEntity(value.rotation)
            })
            .onChange(of: viewModel.model.spin.rotation) {
                if let rotation = viewModel.model.spin.rotation {
                    diceEntity.randomSpin()
                    diceEntity.setOrientation(rotation, relativeTo: nil)
                }
            }
            .onChange(of: viewModel.model.diceEnlargeStrategy.scale) {
                diceEntity.transform.scale = viewModel.model.diceEnlargeStrategy.scale
            }
            .onChange(of: viewModel.model.position) { oldValue, newValue in
                print("viewModel.model.position oldValue: \(oldValue), newValue: \(newValue)")
                diceEntity.transform.translation = newValue
            }
            .onChange(of: viewModel.model.rotation) { _, rotation in
                diceEntity.transform.rotation = rotation
            }

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
