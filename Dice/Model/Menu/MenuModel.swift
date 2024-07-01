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
    case show(dice: MenuDiceModel)
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
    var list: [MenuDiceModel] = MenuDiceModel.getModels()
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

struct MenuDiceModel: Identifiable {
    let id: UUID = UUID()
    
    /// Name of 3D Model to pass the initializer of Entity(RealityKit)
    let modelName: String
    let displayName: String
    let previewImageName: String
    let licenseInfo: String
    let numberOfSides: Int
    
    static func getModels() -> [MenuDiceModel] {
        [
            .init(
                modelName: "Standard",
                displayName: "Standard",
                previewImageName: "standard",
                licenseInfo: """
            Dice "Dice" (https://skfb.ly/GLFs) by Huargenn is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
            """,
                numberOfSides: 6
            ),
            .init(
                modelName: "Chic Red and Blue",
                displayName: "Chic Red and Blue",
                previewImageName: "chic_red_and_blue",
                licenseInfo: """
            "Dice" (https://skfb.ly/6UoEV) by Geug is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
            """,
                numberOfSides: 6
            ),
            .init(
                modelName: "Worn Out",
                displayName: "Worn Out",
                previewImageName: "worn_out",
                licenseInfo: """
            "Dice" (https://skfb.ly/6xKHM) by macriciox is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
            """,
                numberOfSides: 6
            ),
            .init(
                modelName: "Heart",
                displayName: "Heart",
                previewImageName: "heart",
                licenseInfo: """
            "dice with heart" (https://skfb.ly/6RIpW) by yevheniia is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
            """,
                numberOfSides: 6
            ),
            .init(
                modelName: "Summertime",
                displayName: "Summertime",
                previewImageName: "summertime",
                licenseInfo: """
            "Summertime dice" (https://skfb.ly/6RFu7) by Not that Alice is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
            """,
                numberOfSides: 6
            ),
            .init(
                modelName: "Twenty",
                displayName: "Twenty",
                previewImageName: "twenty",
                licenseInfo: """
            "Dice 20" (https://skfb.ly/6A9qA) by Javier.Herrera is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
            """,
                numberOfSides: 20
            ),
            .init(
                modelName: "Oogie Boogie Skull",
                displayName: "Oogie Boogie Skull",
                previewImageName: "oogie_boogie_skull",
                licenseInfo: """
            "Oogie Boogie Skull Dice" (https://skfb.ly/onqnr) by paburoviii is licensed under Creative Commons Attribution (http://creativecommons.org/licenses/by/4.0/).
            """,
                numberOfSides: 6
            ),
        ]
    }
}
