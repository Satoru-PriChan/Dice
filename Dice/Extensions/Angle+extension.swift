//
//  Angle+extension.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/03/25.
//

import Foundation
import Spatial
import simd

extension Angle2D {
    static func create(origin: CGPoint, from pointBeforeMove: CGPoint, to pointAfterMove: CGPoint) -> Angle2D {
        let angleBeforeMove = Angle2D.atan2(y: pointBeforeMove.y - origin.y, x: pointBeforeMove.x - origin.x)
        let angleAfterMove = Angle2D.atan2(y: pointAfterMove.y - origin.y, x: pointAfterMove.x - origin.x)
        if pointBeforeMove != pointAfterMove {
            print("Angle2D create: origin: \(origin), pointBeforeMove: \(pointBeforeMove), pointAfterMove: \(pointAfterMove), angleBeforeMove: \(angleBeforeMove), angleAfterMove: \(angleAfterMove), result(angleAfterMove - angleBeforeMove): \(angleAfterMove - angleBeforeMove)")
        }
        return angleAfterMove - angleBeforeMove
    }
}

extension EulerAngles {
    static func create(
        origin: SIMD3<Float>,
        from pointBeforeMove: simd_float4x4,
        to pointAfterMove: simd_float4x4
    ) -> EulerAngles {
        let x: Angle2D = Angle2D.create(
            origin: CGPoint(x: Double(origin.y), y: Double(origin.z)),
            from: CGPoint(x: Double(pointBeforeMove.columns.3.y), y: Double(pointBeforeMove.columns.3.z)),
            to: CGPoint(x: Double(pointAfterMove.columns.3.y), y: Double(pointAfterMove.columns.3.z))
        )
        let y: Angle2D = Angle2D.create(
            origin: CGPoint(x: Double(origin.x), y: Double(origin.z)),
            from: CGPoint(x: Double(pointBeforeMove.columns.3.x), y: Double(pointBeforeMove.columns.3.z)),
            to: CGPoint(x: Double(pointAfterMove.columns.3.x), y: Double(pointAfterMove.columns.3.z))
        )
        let z: Angle2D = Angle2D.create(
            origin: CGPoint(x: Double(origin.x), y: Double(origin.y)),
            from: CGPoint(x: Double(pointBeforeMove.columns.3.x), y: Double(pointBeforeMove.columns.3.y)),
            to: CGPoint(x: Double(pointAfterMove.columns.3.x), y: Double(pointAfterMove.columns.3.y))
        )
        if pointBeforeMove != pointAfterMove {
            print("EulerAngles create: origin: \(origin), pointBeforeMove: \(pointBeforeMove), pointAfterMove: \(pointAfterMove)")
        }
        return .init(
            x: x,
            y: y,
            z: z,
            order: .xyz
        )
    }
}
