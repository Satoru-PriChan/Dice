//
//  MenuModel.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/06/15.
//

import Foundation

struct MenuModel {
    var diceListModel: MenuDiceListModel = .init()
}

struct MenuDiceListModel {
    var displayType: MenuDiceListDisplayType = .theme
    var list: [MenuDiceListDice] = []
}
///  How to display dice list
enum MenuDiceListDisplayType {
    /// Theme of dice appearance
    case theme
    /// Number of sides of dice
    case numberOfSides
}

struct MenuDiceListDice {
    /// Name of 3D Model to pass the initializer of Entity(RealityKit)
    var modelName: String = ""
}

enum MenuDiceListDiceTheme {
    
}

