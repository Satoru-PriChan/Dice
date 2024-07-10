//
//  MenuViewModel.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/06/26.
//

import Foundation

@MainActor
class MenuDiceListViewModel: ObservableObject {
    @Published var model: MenuModel = .init()

    init() {
        sortDiceList()
    }

    private func sortDiceList() {
        switch model.diceListModel.displayType {
        case .alphabetical:
            model.diceListModel.list.sort{ $0.displayName < $1.displayName }
        case .numberOfSides:
            model.diceListModel.list.sort{ $0.numberOfSides < $1.numberOfSides }
        }
    }
    
    func onIMarkButtonTapped(_ dice: AppDiceModel) {
        model.alertSignal = .show(dice: dice)
    }
    
    
    func onTapAlertOK() {
        model.alertSignal = .hide
    }
    
    func onSelectDisplayType(_ type: MenuDiceListDisplayType) {
        model.diceListModel.displayType = type
        sortDiceList()
    }
}
