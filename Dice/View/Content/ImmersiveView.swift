//
//  ImmersiveView.swift
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

struct ImmersiveView: View {

    @State private var entities: [Entity] = []
    @State private var sceneUpdateSubscription : (any Cancellable)? = nil
    @StateObject private var viewModel: ImmersiveViewModel = ImmersiveViewModel()
    @EnvironmentObject private var appViewModel: AppViewModel
    
    var entityNames: Set<String> {
        Set(entities.map { $0.name })
    }

    var body: some View {
        VStack {
            RealityView(make: { content in
                await viewModel.onMakeRealityView()
                // Called per every frame
                sceneUpdateSubscription = content.subscribe(to: SceneEvents.Update.self) { event in
                    viewModel.onUpdateSceneEvents()
                } as? any Cancellable
                
                // Add the initial RealityKit entity(ies)
                if appViewModel.model.diceSet.isEmpty == false {
                    for dice in appViewModel.model.diceSet {
                        await addEntity(from: dice)
                    }
                }
            }, update: {
                let provided: Set<String> = viewModel.model.diceSet.map { $0.modelName }
                let updated = provided.subtracting(entityNames)
                debugPrint("updated dices: \(updated), provided: \(provided), entityNames: \(entityNames)")
                if updated.isEmpty == false {
                    // Add new entity(ies)
                    for dice in updated {
                        await addEntity(from: dice)
                    }
                }
            })
            .gesture(
                TapGesture()
                    .targetedToAnyEntity()
                    .onEnded { value in
                        let entity = value.entity
                        viewModel.onTapDiceEntity(entity.name)
                    }
            )
            .gesture(
                DragGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in
                        let entity = value.entity
                        viewModel.onDragDiceEntity(
                            entity.name,
                            x: Float(value.translation3D.x),
                            y: Float(value.translation3D.y),
                            z: Float(value.translation3D.z)
                        )
                    }
            )
            .gesture(
                MagnifyGesture()
                    .targetedToAnyEntity()
                    .onChanged { value in
                        let entity = value.entity
                        viewModel.onMagnifyEntity(
                            entity.name,
                            magnification: [
                                Float(value.gestureValue.magnification),
                                Float(value.gestureValue.magnification),
                                Float(value.gestureValue.magnification)
                            ]
                        )
                    }
            )
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
        .onChange(of: viewModel.model.diceSubtractedRotations) { oldValue, newValue in
            guard let diff = newValue.subtracting(oldValue),
                  diff.isEmpty == false else { return }
            
            for diceRotation in diff {
                guard let entity = entities.first(where: { $0.name == diceRotation.key }) else {
                    continue
                }
                // This is animation before the dice is set
                entity.randomSpin()
                entity.setOrientation(diceRotation.rotation, relativeTo: nil)
            }
        }
        .onChange(of: viewModel.model.diceSubtractedEnlarges) { oldValue, newValue in
            guard let diff = newValue.subtracting(oldValue),
                  diff.isEmpty == false else { return }
            
            for diceEnlarge in diff {
                guard let entity = entities.first(where: { $0.name == diceEnlarge.key }) else { continue }
                entity.transform.scale = diceEnlarge.enlarge.scale
            }
        }
        .onChange(of: viewModel.model.diceSubtractedPositions) { oldValue, newValue in
            guard let diff = newValue.subtracting(oldValue),
                  diff.isEmpty == false else { return }
            
            for dicePosition in diff {
                guard let entity = entities.first(where: { $0.name == dicePosition.key }) else { continue }
                entity.position = dicePosition.position
            }
        }
        .onChange(of: viewModel.model.diceSubtractedMagnifies) { oldValue, newValue in
            guard let diff = newValue.subtracting(oldValue),
                  diff.isEmpty == false else { return }
            
            for diceMagnify in diff {
                guard let entity = entities.first(where: { $0.name == diceMagnify.key }) else { continue }
                entity.transform.scale = diceMagnify.magnify
            }
        }
        .onChange(of: appViewModel.model.diceSet) { oldValue, newValue in
            let insertedDices = newValue.subtracting(oldValue)
            guard insertedDices.isEmpty == false else { return }
            for insertedDice in insertedDices {
                // TODO: - Show 3D Entities
            }
        }

    }
    
    private func addEntity(from model: ImmersiveDiceModel) async throws {
        guard entities.count < 11 else {
            debugPrint("Already added \(entities.count) entities.")
            return
        }
        
        guard let diceEntity = try? await Entity(named: model.modelName, in: diceContentBundle) else {
            debugPrint("Cannot get entity: \(model.modelName)")
            return
        }
        
        diceEntity.name = model.modelName
        diceEntity.position = model.position
        entities.append(diceEntity)
    }
}

#Preview(windowStyle: .plain) {
    ImmersiveView()
}
