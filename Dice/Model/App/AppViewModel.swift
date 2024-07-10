//
//  AppViewModel.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/07/10.
//

import Foundation

final class AppViewModel: ObservableObject {
    @Published
    var model: AppModel = .init()
    
    func onTapShowEntityButton(_ dice: AppDiceModel) {
        switch model.displayImmersiveSpaceStrategy {
        case .show(let entities):
            var entities = entities
            entities.append(dice)
            model.displayImmersiveSpaceStrategy = .show(entities: entities)
        case .hide:
            model.displayImmersiveSpaceStrategy = .show(entities: [dice])
        }
        
    }
}
