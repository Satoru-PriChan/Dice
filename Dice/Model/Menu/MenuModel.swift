//
//  MenuModel.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/06/15.
//

import Foundation
import SwiftUI

struct MenuModel {
    var diceListModel: MenuDiceListModel = .init()
    var alertSignal: MenuAlertSignal = .hide
}

enum MenuAlertSignal {
    case show(dice: AppDiceModel)
    case hide
    
    var shouldShow: Bool {
        switch self {
        case .show(_):
            true
        case .hide:
            false
        }
    }
    
    var message: String {
        switch self {
        case .show(let dice):
            dice.licenseInfo
        case .hide:
            ""
        }
    }
}

struct MenuDiceListModel {
    var displayType: MenuDiceListDisplayType = .alphabetical
    var list: [AppDiceModel] = AppDiceModel.getModels()
}
///  How to display dice list
enum MenuDiceListDisplayType: CaseIterable, Identifiable {
    /// alphabetical order
    case alphabetical
    /// Number of sides of dice
    case numberOfSides
    
    // MARK: Identifiable
    var id: Self { self }
    
    var displayName: String {
        switch self {
        case .alphabetical:
            return "Alphabetical"
        case .numberOfSides:
            return "Number of sides"
        }
    }
}
