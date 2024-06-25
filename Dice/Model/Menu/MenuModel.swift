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
    var list: [MenuDiceModel] = []
}
///  How to display dice list
enum MenuDiceListDisplayType {
    /// Theme of dice appearance
    case theme
    /// Number of sides of dice
    case numberOfSides
}

struct MenuDiceModel {
    /// Name of 3D Model to pass the initializer of Entity(RealityKit)
    var modelName: String = ""
    var displayName: String = ""
    
    /// ???
    //var image
}

enum MenuDiceListDiceTheme {
    
}

