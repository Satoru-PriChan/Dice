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

    private let attachmentID = "attachment_id"
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
            RealityView { content, attachments in
                debugPrint("⭐️ RealityView make")
                await viewModel.onMakeRealityView(appViewModel.model.diceSet)
                // Called per every frame
                sceneUpdateSubscription = content.subscribe(to: SceneEvents.Update.self) { event in
                    viewModel.onUpdateSceneEvents()
                } as? any Cancellable
                
                // Initial Dice setup
                do {
                    let models = viewModel.model.diceSet
                    let entities = try await createEntities(models)
                    entities.forEach { content.add($0) }
                    self.entities = entities
                } catch {
                    debugPrint(error.localizedDescription)
                }
                
                if let attachment = attachments.entity(for: attachmentID) {
                    content.add(attachment)
                }
            } update: { content, attachments in
                // Update
                debugPrint("⭐️ RealityView update")

                let models = viewModel.model.diceSet
                let newValuesSet: Set<String> = Set<String>(models.map { $0.modelName })
                let oldValuesSet: Set<String> = Set<String>(entities.map { $0.name })
                
                // Addition
                let added: Set<String> = newValuesSet.subtracting(oldValuesSet)
                added.forEach {
                    if let entity = try? Entity.load(named: $0) {
                        content.add(entity)
                        self.entities.append(entity)
                    }
                }
                // Deletion
                let deleted = oldValuesSet.subtracting(newValuesSet)
                deleted.forEach { deletedName in
                    if let deletedEntity = self.entities.first(where: { $0.name == deletedName }),
                       let deletedIndex = self.entities.firstIndex(of: deletedEntity) {
                        content.remove(deletedEntity)
                        self.entities.remove(at: deletedIndex)
                    }
                }
            } placeholder: {
                ProgressView()
            } attachments: {
                Attachment(id: attachmentID) {
                    Toggle(
                        "Enlarge RealityView Content",
                        isOn: .init(
                            get: {
                                viewModel.model.diceSet.randomElement()?.diceEnlargeStrategy.isOnEnlargement ?? false
                            },
                            set: {
                                isOn in viewModel.onToggleTapped(isOn: isOn)
                            }
                        )
                    )
                    .toggleStyle(.button)
                    .padding()
                    .glassBackgroundEffect()
                }
            }
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
            debugPrint("⭐️.onChange(of: appViewModel.model.diceSet: \(appViewModel.model.diceSet)")
            viewModel.onChangeAppDiceSet(newValue)
        }
    }
    
    @MainActor
    private func createEntities(
        _ dices: Set<ImmersiveDiceModel>
    ) async throws -> [Entity] {
        try await withThrowingTaskGroup(of: Entity.self) { group in
            var result: [Entity] = []
            for dice in dices {
                group.addTask {
                    try await addEntity(from: dice)
                }
                for try await entity in group {
                    result.append(entity)
                }
            }
            return result
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
        return diceEntity
    }
}

#Preview(windowStyle: .plain) {
    ImmersiveView()
}
