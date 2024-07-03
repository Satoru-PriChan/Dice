//
//  DiceTest.swift
//  DiceTests
//
//  Created by kento.yamazaki on 2024/07/03.
//

import Testing
@testable import Dice

@Suite("Tests of ContentViewModel")
actor DiceContentViewModelTestActor {

    @Test
    func randomeSpin() async throws {
        let viewModel = await ContentViewModel()
        let model = await viewModel.model
        // Expect the initial value is five
        #expect(model.spin == .five)
        var result: [ContentDiceSpinStrategy] = []
        // Test ratio of each side of dice after 1000 random spins
        for _ in 0...999 {
            await viewModel.onTapDiceEntity()
            let model = await viewModel.model
            result.append(model.spin)
        }
        for target in ContentDiceSpinStrategy.allCases {
            #expect(
                result.count(where: { spin in
                    if case target = spin {
                        return true
                    } else {
                        return false
                    }
                })
                 >= 10
            )
        }
    }

}
