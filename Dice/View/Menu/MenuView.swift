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
    @StateObject private var viewModel: MenuDiceListViewModel = MenuDiceListViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                // Display mode change button
                Picker(
                    selection: Binding<MenuDiceListDisplayType>(
                        get: { viewModel.model.diceListModel.displayType },
                        set: { type in
                            viewModel.onSelectDisplayType(type)
                        }
                    ),
                    content: {
                        ForEach(MenuDiceListDisplayType.allCases) { type in
                            Text(type.displayName).tag(type)
                        }
                    }, label: {
                        Text("Display Order")
                            .frame(width: 600)
                    })
                    
                
                // 2Dlist
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.fixed(550)),
                        GridItem(.fixed(550))
                    ]) {
                        ForEach(viewModel.model.diceListModel.list) { dice in
                            Button(action: {
                                // Show 3D Entity
                                print("Show 3D Entity")
                            }, label: {
                                HStack {
                                    // 3D Entity preview
                                    Image(dice.previewImageName)
                                        .resizable()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(20)
                                        .padding()
                                    
                                    // Entity name
                                    Text(dice.displayName)
                                        .frame(width: 275)
                                    
                                    // i mark button (license info)
                                    Button(action: {
                                        viewModel.onIMarkButtonTapped(dice)
                                    }) {
                                        Image(systemName: "info.circle")
                                    }
                                    .frame(width: 44.0, height: 44.0)
                                }
                                .frame(maxWidth: .infinity)
                            })
                        }
                    }
                    .padding()
                }
                .navigationTitle("Dice")
            }
        }
        .alert(
            viewModel.model.alertSignal.message,
            isPresented: Binding<Bool>(
                get: {
                    viewModel.model.alertSignal.shouldShow
                }, set: {_ in })
        ) {
            Button("OK") {
                viewModel.onTapAlertOK()
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
