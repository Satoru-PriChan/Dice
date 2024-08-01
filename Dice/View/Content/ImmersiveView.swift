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
    
    @MainActor
    private var content: some View {
        VStack {
            RealityView(make: { content in
                await viewModel.onMakeRealityView()
                // Called per every frame
                sceneUpdateSubscription = content.subscribe(to: SceneEvents.Update.self) { event in
                    viewModel.onUpdateSceneEvents()
                } as? any Cancellable
                
                // Initial setup
                let models = viewModel.model.diceSet
                addEntities(models, to: &content)
            }, update: { content in
                // Update
                let models = viewModel.model.diceSet
                addEntities(models, to: &content)
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
//            VStack {
//                Toggle(
//                    "Enlarge RealityView Content",
//                    isOn: .init(
//                        get: { viewModel.model.diceEnlargeStrategy.isOnEnlargement },
//                        set: { isOn in viewModel.onToggleTapped(isOn) }
//                    )
//                )
//                    .toggleStyle(.button)
//            }.padding().glassBackgroundEffect()
        }

    }

    var body: some View {
        content
                .onChange(of: viewModel.model.diceSubtractedRotations) { oldValue, newValue in
            let diff: Set<ImmersiveSubtractedDiceRotation> = newValue.symmetricDifference(oldValue)
            guard diff.isEmpty == false else { return }
            
            for diceRotation in diff {
                guard let entity: Entity = entities.first(where: { $0.name == diceRotation.key }) else {
                    continue
                }
                // This is animation before the dice is set
                entity.randomSpin()
                entity.setOrientation(diceRotation.rotation, relativeTo: nil)
            }
        }
        .onChange(of: viewModel.model.diceSubtractedEnlarges) { oldValue, newValue in
            let diff: Set<ImmersiveSubtractedDiceEnlarge> = newValue.symmetricDifference(oldValue)
            guard diff.isEmpty == false else { return }
            
            for diceEnlarge in diff {
                guard let entity: Entity = entities.first(where: { $0.name == diceEnlarge.key }) else { continue }
                entity.transform.scale = diceEnlarge.enlarge.scale
            }
        }
        .onChange(of: viewModel.model.diceSubtractedPositions) { oldValue, newValue in
            let diff: Set<ImmersiveSubtractedDicePosition> = newValue.symmetricDifference(oldValue)
            guard diff.isEmpty == false else { return }
            
            for dicePosition in diff {
                guard let entity: Entity = entities.first(where: { $0.name == dicePosition.key }) else { continue }
                entity.position = dicePosition.position
            }
        }
        .onChange(of: viewModel.model.diceSubtractedMagnifies) { oldValue, newValue in
            let diff: Set<ImmersiveSubtractedDiceMagnify> = newValue.symmetricDifference(oldValue)
            guard diff.isEmpty == false else { return }
            
            for diceMagnify in diff {
                guard let entity: Entity = entities.first(where: { $0.name == diceMagnify.key }) else { continue }
                entity.transform.scale = diceMagnify.magnify
            }
        }
        .onChange(of: appViewModel.model.diceSet) { oldValue, newValue in
            viewModel.onChangeAppDiceSet(newValue)
        }
    }
    
    @MainActor
    private func addEntities(
        _ dices: Set<ImmersiveDiceModel>,
        to content: inout RealityViewContent
    ) {
        var entities: [Entity] = []
        if dices.isEmpty == false {
            dices.forEach { model in
                Task {
                    let entity = try await addEntity(from: model)
                    entities.append(entity)
                }
            }
            entities.forEach { entity in
                content.add(entity)
            }
        }
    }
    
    private func addEntity(from model: ImmersiveDiceModel) async throws -> Entity  {
        guard entities.count < 11 else {
            debugPrint("Already added \(entities.count) entities.")
            throw NSError(domain: "ImmsersiveView", code: 1, userInfo: ["userInfo": "Already added \(entities.count) entities."])
        }
        
        guard let diceEntity = try? await Entity(named: model.modelName, in: diceContentBundle) else {
            debugPrint("Cannot get entity: \(model.modelName)")
            throw NSError(domain: "ImmsersiveView", code: 2, userInfo: ["userInfo": "Cannot get entity: \(model.modelName)"])
        }
        
        diceEntity.name = model.modelName
        diceEntity.position = model.position
        entities.append(diceEntity)
        return diceEntity
    }
}

#Preview(windowStyle: .plain) {
    ImmersiveView()
}
