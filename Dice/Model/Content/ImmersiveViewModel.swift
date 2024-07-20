//
//  ImmersiveViewModel.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/04/03.
//

import ARKit
import Combine
import Foundation
import QuartzCore

@MainActor
final class ImmersiveViewModel: ObservableObject {
    
    private let session = ARKitSession()
    private let worldInfoProvider = WorldTrackingProvider()
    @Published
    var model: ImmersiveModel = ImmersiveModel()

    func onMakeRealityView() async {
        try? await session.run([worldInfoProvider])
    }
    
    func onUpdateSceneEvents() {
        // Example
        //        guard let pose = worldInfoProvider.queryDeviceAnchor(atTimestamp: CACurrentMediaTime()) else { return }
        //        let originFromAnchorTransform = pose.originFromAnchorTransform
    }

    func onTapDiceEntity(_ modelName: String) {
        var dice = findDice(modelName)
        dice.randomSpin()
        model.diceSet.update(with: dice)
    }
    
    func onDragDiceEntity(_ modelName: String, x: Float, y: Float, z: Float) {
        var dice = findDice(modelName)
        dice.position.x += x*0.0001
        dice.position.y += y*0.0001
        dice.position.z += z*0.0001
        model.diceSet.update(with: dice)
    }
    
    func onMagnifyEntity(_ modelName: String, magnification: SIMD3<Float>) {
        var dice = findDice(modelName)
        dice.magnify = magnification
        model.diceSet.update(with: dice)
    }
    
    func onToggleTapped(_ modelName: String, isOn: Bool) {
        var dice = findDice(modelName)
        dice.diceEnlargeStrategy = .init(isOn)
        model.diceSet.update(with: dice)
    }
    
    private func findDice(_ modelName: String) -> ImmersiveDiceModel {
        guard var dice = model.diceSet.first(where: { $0.modelName == modelName}) else {
            fatalError("Cannot found model name: \(modelName)")
        }
        return dice
    }
}
