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

    func onTapDiceEntity(_ dice: ImmersiveDiceModel) {
        var dice = dice
        dice.randomSpin()
        model.diceSet.update(with: dice)
    }
    
    func onDragDiceEntity(_ dice: ImmersiveDiceModel, x: Float, y: Float, z: Float) {
        var dice = dice
        dice.position.x += x*0.0001
        dice.position.y += y*0.0001
        dice.position.z += z*0.0001
        model.diceSet.update(with: dice)
    }
    
    func onMagnifyEntity(_ dice: ImmersiveDiceModel, magnification: SIMD3<Float>) {
        var dice = dice
        dice.magnify = magnification
        model.diceSet.update(with: dice)
    }
    
    func onToggleTapped(_ dice: ImmersiveDiceModel, isOn: Bool) {
        var dice = dice
        dice.diceEnlargeStrategy = .init(isOn)
        model.diceSet.update(with: dice)
    }
}
