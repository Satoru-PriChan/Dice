//
//  Entity+extension.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/04/25.
//

import Foundation
import RealityKit
import simd

extension Entity {
    func randomSpin() {
        for _ in 0...100 {
            self.move(
                to: Transform(
                    pitch: Float.randomAngle(),
                    yaw: Float.randomAngle(),
                    roll: Float.randomAngle()
                ),
                relativeTo: self,
                duration: 0.01
            )
        }
    }
}
