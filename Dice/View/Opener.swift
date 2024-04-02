//
//  Opener.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/03/16.
//

import SwiftUI

struct Opener: View {
    @Environment(\.openImmersiveSpace)
    var openImmersiveSpace: OpenImmersiveSpaceAction
    @Environment(\.dismissImmersiveSpace)
    var dismissImmersiveSpace: DismissImmersiveSpaceAction
    @State
    var isShown: Bool = false
    
    var body: some View {
        Button(action: {
            Task {
                if isShown {
                    await dismissImmersiveSpace()
                } else {
                    await openImmersiveSpace(id: "Dice")
                }
                isShown.toggle()
            }
        }, label: {
            if isShown {
                Text("Hide Dice")
            } else {
                Text("Show Dice")
            }
        })
    }
}

#Preview {
    Opener()
}
