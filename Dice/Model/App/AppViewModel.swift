//
//  AppViewModel.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/06/15.
//

import ARKit
import Combine
import Foundation
import QuartzCore

final class AppViewModel: ObservableObject {
    @Published
    var model: AppModel = AppModel()
}
