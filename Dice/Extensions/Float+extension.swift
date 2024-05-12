//
//  Float+extension.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/05/11.
//

import Foundation

public extension Float {
    static func randomAngle() -> Float {
        Self.random(in: 0.0...2*Float.pi)
    }
}
