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

    /// Called on making reality view. This method starts AR session. Also, receive initial set of AppDiceModel to reflect it to the view model.
    /// This method should be called only once at initialization of RealityView
    /// - Parameter newValue: [AppDiceModel]. Pass initial set of AppDiceModel to reflect it to the view model.
    func onMakeRealityView(_ newValue: [AppDiceModel]) async {
        // Start AR session
        try? await session.run([worldInfoProvider])
        // Receive initial AppDiceModel
        onChangeAppDiceSet(newValue)
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
    
    func onToggleTapped(isOn: Bool) {
        var result: Set<ImmersiveDiceModel> =  Set<ImmersiveDiceModel>()
        model.diceSet.forEach { dice in
            var dice = dice
            dice.diceEnlargeStrategy = .init(isOn)
            result.insert(dice)
        }
        model.diceSet = result
    }
    
    func onChangeAppDiceSet(_ newValue: [AppDiceModel]) {
        model.diceSet = ImmersiveTranslator.translate(newValue)
    }
    
    private func findDice(_ modelName: String) -> ImmersiveDiceModel {
        guard let dice = model.diceSet.first(where: { $0.modelName == modelName}) else {
            fatalError("Cannot found model name: \(modelName)")
        }
        return dice
    }
}
