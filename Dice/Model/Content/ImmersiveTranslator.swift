//
//  ImmersiveTranslator.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/07/27.
//

import Foundation

enum ImmersiveTranslator {
    static func translate(_ appDiceModelSet: Set<AppDiceModel>) -> Set<ImmersiveDiceModel> {
        Set<ImmersiveDiceModel>(appDiceModelSet.map { Self.translate($0) })
    }
    
    private static func translate(_ model: AppDiceModel) -> ImmersiveDiceModel {
        ImmersiveDiceModel(modelName: model.modelName)
    }
}
