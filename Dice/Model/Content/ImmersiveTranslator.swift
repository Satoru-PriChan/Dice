//
//  ImmersiveTranslator.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/07/27.
//

import Foundation

enum ImmersiveTranslator {
    static func translate(_ appDiceModelList: [AppDiceModel]) -> Set<ImmersiveDiceModel> {
        var result: [ImmersiveDiceModel] = []
        for (number, element) in appDiceModelList.enumerated() {
            result.append(Self.translate(element, at: number))
        }
        return Set<ImmersiveDiceModel>(result)
    }
    
    private static func translate(_ model: AppDiceModel, at index: Int) -> ImmersiveDiceModel {
        var model = ImmersiveDiceModel(modelName: model.modelName)
        model.position = ImmersiveModel.initialPositions[index]
        return model
    }
}
