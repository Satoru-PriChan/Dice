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

    func onTapDiceEntity() {
        model.spin = ImmersiveDiceSpinStrategy.allCases.randomElement() ?? .five
        print("spin: \(model.spin)")
    }
    
    func onDragDiceEntity(x: Float, y: Float, z: Float) {
        model.position.x += x*0.0001
        model.position.y += y*0.0001
        model.position.z += z*0.0001
    }
    
    func onMagnifyEntity(_ magnification: SIMD3<Float>) {
        model.magnify = magnification
    }
    
    func onToggleTapped(_ isOn: Bool) {
        model.diceEnlargeStrategy = .init(isOn)
    }
}
