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
}

struct ContentLookParam {
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
