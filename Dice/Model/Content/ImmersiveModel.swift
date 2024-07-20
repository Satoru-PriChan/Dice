//
//  ImmersiveModel.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/04/03.
//

import Foundation
import simd


struct ImmersiveModel {
    var diceSet: Set<ImmersiveDiceModel> = Set<ImmersiveDiceModel>()
}

struct ImmersiveDiceModel {
    /// Name of 3D Model to pass the initializer of Entity(RealityKit)
    var modelName: String
    var diceEnlargeStrategy: ImmersiveDiceEnlargeStrategy = .normal
    var spinType: ImmersiveSpinType = .sixSides
    var spinOfSixSides: ImmersiveSixSidesDiceSpinStrategy = .back
    var spinOfTwentySides: ImmersiveTwentySidesDiceSpinStrategy = .one
    /// Entity's position
    var position: SIMD3<Float> = .init(x: 0.0, y: 1.5, z: -1.0)// Just in front of the user's face
    var magnify: SIMD3<Float> = [1.0, 1.0, 1.0]
    
    mutating func randomSpin() {
        switch spinType {
        case .sixSides:
            self.spinOfSixSides = ImmersiveSixSidesDiceSpinStrategy.allCases.randomElement() ?? .bottom
        case .twentySides:
            self.spinOfTwentySides = ImmersiveTwentySidesDiceSpinStrategy.allCases.randomElement() ?? .one
        }
    }
}

extension ImmersiveDiceModel: Hashable {
    static func == (lhs: ImmersiveDiceModel, rhs: ImmersiveDiceModel) -> Bool {
        return lhs.modelName == rhs.modelName
    }


    func hash(into hasher: inout Hasher) {
        hasher.combine(modelName)
        debugPrint("modelName: \(modelName), hasher.finalize(): \(hasher.finalize())")
    }
}

enum ImmersiveDiceEnlargeStrategy {
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
    
    func toggle() -> ImmersiveDiceEnlargeStrategy {
        switch self {
        case .normal:
            .enlarge
        case .enlarge:
            .normal
        }
    }
}

enum ImmersiveSpinType {
    case sixSides
    case twentySides
}

enum ImmersiveSixSidesDiceSpinStrategy: CaseIterable {
    case front
    case top
    case right
    case left
    case back
    case bottom
    
    var rotation: simd_quatf? {
        switch self {
        case .front:
            return .init(angle: .zero, axis: .init(x: 1, y: 0, z: 0))
        case .top:
            return .init(angle: Float.pi / 2, axis: .init(x: 1, y: 0, z: 0))
        case .right:
            return .init(angle: Float.pi * 3 / 2, axis: .init(x: 0, y: 1, z: 0))
        case .left:
            return .init(angle: Float.pi / 2, axis: .init(x: 0, y: 1, z: 0))
        case .back:
            return .init(angle: Float.pi, axis: .init(x: 1, y: 0, z: 0))
        case .bottom:
            return .init(angle: Float.pi * 3 / 2, axis: .init(x: 1, y: 0, z: 0))
        }
    }
}

enum ImmersiveTwentySidesDiceSpinStrategy: CaseIterable {
    case one
    case two
}
