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
    /// Dice names and rotations. Both informaion is stored in diceSet, but this property forms it usable in onChange() of View. This property is just a computed property.
    var diceSubtractedRotations: Set<ImmersiveSubtractedDiceRotation> {
        var result: Set<ImmersiveSubtractedDiceRotation> = Set<ImmersiveSubtractedDiceRotation>()
        for dice in diceSet {
            result.insert(.init(key: dice.modelName, rotation: dice.rotation))
        }
        return result
    }
    var diceSubtractedEnlarges: Set<ImmersiveSubtractedDiceEnlarge> {
        var result: Set<ImmersiveSubtractedDiceEnlarge> = Set<ImmersiveSubtractedDiceEnlarge>()
        for dice in diceSet {
            result.insert(.init(key: dice.modelName, enlarge: dice.diceEnlargeStrategy))
        }
        return result
    }
    var diceSubtractedPositions: Set<ImmersiveSubtractedDicePosition> {
        var result: Set<ImmersiveSubtractedDicePosition> = Set<ImmersiveSubtractedDicePosition>()
        for dice in diceSet {
            result.insert(.init(key: dice.modelName, position: dice.position))
        }
        return result
    }
    var diceSubtractedMagnifies: Set<ImmersiveSubtractedDiceMagnify> {
        var result: Set<ImmersiveSubtractedDiceMagnify> = Set<ImmersiveSubtractedDiceMagnify>()
        for dice in diceSet {
            result.insert(.init(key: dice.modelName, magnify: dice.magnify))
        }
        return result
    }
    /// Entity's initial positions(fixed)
    private let initialPositions: [SIMD3<Float>] = [
        .init(x: 0.0, y: 1.5, z: -1.0),// Just in front of the user's face
        .init(x: 2.0, y: 1.5, z: -1.0),
        .init(x: -2.0, y: 1.5, z: -1.0),
        .init(x: 0.0, y: 3.5, z: -1.0),
        .init(x: 2.0, y: 3.5, z: -1.0),
        .init(x: -2.0, y: 3.5, z: -1.0),
        .init(x: 0.0, y: 1.75, z: -3.0),
        .init(x: 2.0, y: 1.75, z: -3.0),
        .init(x: -2.0, y: 1.75, z: -3.0),
        .init(x: 0.0, y: 1.25, z: -3.0),
    ]
}

/// Rotation（回転）情報
/// Viewで使いやすくするため、ImmersiveModelより情報を抽出して初期化することを想定
struct ImmersiveSubtractedDiceRotation {
    let key: String
    let rotation: simd_quatf
}

extension ImmersiveSubtractedDiceRotation: Hashable {
    static func == (lhs: ImmersiveSubtractedDiceRotation, rhs: ImmersiveSubtractedDiceRotation) -> Bool {
        return lhs.key == rhs.key && lhs.rotation == rhs.rotation
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(rotation)
        debugPrint("key: \(key), rotation: \(rotation) hasher.finalize(): \(hasher.finalize())")
    }
}

/// Enlarge(拡大)情報
/// Viewで使いやすくするため、ImmersiveModelより情報を抽出して初期化することを想定
struct ImmersiveSubtractedDiceEnlarge {
    let key: String
    let enlarge: ImmersiveDiceEnlargeStrategy
}

extension ImmersiveSubtractedDiceEnlarge: Hashable {
    static func == (lhs: ImmersiveSubtractedDiceEnlarge, rhs: ImmersiveSubtractedDiceEnlarge) -> Bool {
        return lhs.key == rhs.key && lhs.enlarge == rhs.enlarge
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(enlarge)
        debugPrint("key: \(key), enlarge: \(enlarge) hasher.finalize(): \(hasher.finalize())")
    }
}

/// Position（位置）情報
/// Viewで使いやすくするため、ImmersiveModelより情報を抽出して初期化することを想定
struct ImmersiveSubtractedDicePosition {
    let key: String
    let position: SIMD3<Float>
}

extension ImmersiveSubtractedDicePosition: Hashable {
    static func == (lhs: ImmersiveSubtractedDicePosition, rhs: ImmersiveSubtractedDicePosition) -> Bool {
        return lhs.key == rhs.key && lhs.position == rhs.position
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(position)
        debugPrint("key: \(key), position: \(position) hasher.finalize(): \(hasher.finalize())")
    }
}

/// Magnify(ピンチによる拡大)情報
/// Viewで使いやすくするため、ImmersiveModelより情報を抽出して初期化することを想定
struct ImmersiveSubtractedDiceMagnify {
    let key: String
    let magnify: SIMD3<Float>
}

extension ImmersiveSubtractedDiceMagnify: Hashable {
    static func == (lhs: ImmersiveSubtractedDiceMagnify, rhs: ImmersiveSubtractedDiceMagnify) -> Bool {
        return lhs.key == rhs.key && lhs.magnify == rhs.magnify
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
        hasher.combine(magnify)
        debugPrint("key: \(key), magnify: \(magnify) hasher.finalize(): \(hasher.finalize())")
    }
}

struct ImmersiveDiceModel {
    init(modelName: String) {
        self.modelName = modelName
    }
    
    /// Name of 3D Model to pass the initializer of Entity(RealityKit)
    var modelName: String
    var diceEnlargeStrategy: ImmersiveDiceEnlargeStrategy = .normal
    var position: SIMD3<Float> = .init(x: 0.0, y: 1.5, z: -1.0)// Just in front of the user's face
    var magnify: SIMD3<Float> = [1.0, 1.0, 1.0]
    var spinType: ImmersiveSpinType = .sixSides
    var rotation: simd_quatf {
        switch spinType {
        case .sixSides:
            spinOfSixSides.rotation
        case .twentySides:
            spinOfTwentySides.rotation
        }
    }
    private var spinOfSixSides: ImmersiveSixSidesDiceSpinStrategy = .back
    private var spinOfTwentySides: ImmersiveTwentySidesDiceSpinStrategy = .one
    
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
    
    var rotation: simd_quatf {
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
    
    var rotation: simd_quatf {
        switch self {
        case .one:
            return .init(angle: .zero, axis: .init(x: 1, y: 0, z: 0))
        case .two:
            return .init(angle: Float.pi / 2, axis: .init(x: 1, y: 0, z: 0))
        }
    }
}
