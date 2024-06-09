//
//  MenuView.swift
//  Dice
//
//  Created by kento.yamazaki on 2024/06/04.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        TabView {
            MenuDiceListView()
                .tabItem {
                    Label("Dice List", systemImage: "square.grid.3x3.topleft.filled")
                }
        }
    }
}

struct MenuDiceListView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Dice List View")
                    .font(.largeTitle)
                    .padding()
                Opener()
                Spacer()
            }
            .navigationTitle("Dice")
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
