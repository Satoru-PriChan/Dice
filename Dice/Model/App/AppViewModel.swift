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
        if model.shouldShowImmersiveView == false {
            model.shouldShowImmersiveView = true
        }
        
        model.diceList.append(dice)
    }
}
