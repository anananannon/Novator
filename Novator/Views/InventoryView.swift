// InventoryView.swift
import SwiftUI

struct InventoryView: View {
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel // Переименовано для ясности
    
    private let gridSpacing: CGFloat = 7
    private let sidePadding: CGFloat = 12
    private let columns = 3

    private var itemSize: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (screenWidth - sidePadding * 2 - gridSpacing * CGFloat(columns - 1)) / CGFloat(columns)
    }

    // Equipped
    private var equippedAccessories: [Accessory] {
        userProfileViewModel.profile.equippedAccessories.compactMap { AccessoryManager.accessory(forName: $0) }
    }

    // Unequipped in inventory
    private var unequippedAccessories: [Accessory] {
        let ownedNames = Set(userProfileViewModel.profile.inventory)
        let equippedNames = Set(userProfileViewModel.profile.equippedAccessories)
        let unequippedNames = ownedNames.subtracting(equippedNames)
        return unequippedNames.compactMap { AccessoryManager.accessory(forName: $0) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("ProfileBackground").ignoresSafeArea()
                ScrollView {
                    LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                        if !equippedAccessories.isEmpty {
                            Section(header: sectionHeader(title: "НАДЕНЫ")) {
                                accessoriesGrid(equippedAccessories, isEquipped: true)
                            }
                        }

                        if !unequippedAccessories.isEmpty {
                            Section(header: sectionHeader(title: "В ИНВЕНТАРЕ")) {
                                accessoriesGrid(unequippedAccessories, isEquipped: false)
                            }
                        } else if equippedAccessories.isEmpty {
                            Text("Инвентарь пуст. Купите аксессуары в магазине!").foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Инвентарь")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(userProfileViewModel.theme.colorScheme)
        }
    }

    private func accessoriesGrid(_ accessories: [Accessory], isEquipped: Bool) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.fixed(itemSize), spacing: gridSpacing), count: columns),
            spacing: gridSpacing
        ) {
            ForEach(accessories) { accessory in
                InventoryAccessorySquare(
                    accessory: accessory,
                    isEquipped: isEquipped,
                    size: itemSize,
                    profile: _userProfileViewModel
                )
            }
        }
        .padding(.horizontal, sidePadding)
    }

    private func sectionHeader(title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(.subheadline, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 17)
                .padding(.vertical, 5)
            Spacer()
        }
        .background(Color("SectionBackground"))
    }
}
