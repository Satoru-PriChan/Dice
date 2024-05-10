//
//  ContentViewModel.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/04/03.
//

import ARKit
import Combine
import Foundation
import QuartzCore

class ContentViewModel: ObservableObject {
    
    private let session = ARKitSession()
    private let worldInfoProvider = WorldTrackingProvider()

    let entityInitialPosition: SIMD3<Float> = .init(x: 0.0, y: 1.5, z: -1.0)// Just in front of the user's face
    @Published
    var model: ContentModel = ContentModel()

    func onMakeRealityView() async {
        try? await session.run([worldInfoProvider])
    }
    
    func onUpdateSceneEvents() {
        guard let pose = worldInfoProvider.queryDeviceAnchor(atTimestamp: CACurrentMediaTime()) else { return }
        let originFromAnchorTransform = pose.originFromAnchorTransform
        // Keep the entity looking at the device position
        model.look = .init(at: originFromAnchorTransform.translation, from: entityInitialPosition)
    }

    func onTapDiceEntity() {
        model.spin = ContentDiceSpinStrategy.allCases.randomElement() ?? .five
        print("spin: \(model.spin)")
    }
    
    func onToggleTapped(_ isOn: Bool) {
        model.diceEnlargeStrategy = .init(isOn)
    }
}
