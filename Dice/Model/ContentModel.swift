//
//  ContentModel.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/04/03.
//

import Foundation
import simd


struct ContentModel {
    var look: ContentLookParam? = nil
    var diceEnlargeStrategy: ContentDiceEnlargeStrategy = .normal
    var spin: ContentDiceSpinStrategy = .five
}

struct ContentLookParam: Equatable {
    let at: SIMD3<Float>
    let from: SIMD3<Float>
}

enum ContentDiceEnlargeStrategy {
    case normal
    case enlarge
    
    init(_ isOn: Bool) {
        self = isOn ? .enlarge : .normal
    }
    
    var scale: SIMD3<Float> {
        switch self {
        case .normal:
            [1.0, 1.0, 1.0]
        case .enlarge:
            [1.4, 1.4, 1.4]
        }
    }
    
    var isOnEnlargement: Bool {
        switch self {
        case .normal:
            false
        case .enlarge:
            true
        }
    }
    
    func toggle() -> ContentDiceEnlargeStrategy {
        switch self {
        case .normal:
            .enlarge
        case .enlarge:
            .normal
        }
    }
}

enum ContentDiceSpinStrategy: CaseIterable {
    case one
    case two
    case three
    case four
    case five
    case six
    
    var rotation: simd_quatf? {
        switch self {
        case .one:
            return .init(angle: .zero, axis: .init(x: 1, y: 0, z: 0))
        case .two:
            return .init(angle: Float.pi / 2, axis: .init(x: 1, y: 0, z: 0))
        case .three:
            return .init(angle: Float.pi * 3 / 2, axis: .init(x: 0, y: 1, z: 0))
        case .four:
            return .init(angle: Float.pi / 2, axis: .init(x: 0, y: 1, z: 0))
        case .five:
            return .init(angle: Float.pi, axis: .init(x: 1, y: 0, z: 0))
        case .six:
            return .init(angle: Float.pi * 3 / 2, axis: .init(x: 1, y: 0, z: 0))
        }
    }
}
