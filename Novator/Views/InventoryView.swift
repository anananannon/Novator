import SwiftUI

struct InventoryView: View {
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    
    private let gridSpacing: CGFloat = 7
    private let sidePadding: CGFloat = 12
    private let columns = 3

    private var itemSize: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (screenWidth - sidePadding * 2 - gridSpacing * CGFloat(columns - 1)) / CGFloat(columns)
    }

    // Все аксессуары из инвентаря, надетые — первыми
    private var allAccessories: [Accessory] {
        let accessories = userProfileViewModel.profile.inventory.compactMap { AccessoryManager.accessory(forName: $0) }
        return accessories.sorted { a, b in
            let aIsEquipped = userProfileViewModel.profile.equippedAccessories.contains(a.name)
            let bIsEquipped = userProfileViewModel.profile.equippedAccessories.contains(b.name)
            return aIsEquipped && !bIsEquipped // Надетые (true) идут перед ненадетыми (false)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("ProfileBackground").ignoresSafeArea()
                ScrollView {
                    LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                        if !allAccessories.isEmpty {
                            Section(header: sectionHeader(title: "АКСЕССУАРЫ")) {
                                accessoriesGrid(allAccessories)
                            }
                        } else {
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

    private func accessoriesGrid(_ accessories: [Accessory]) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.fixed(itemSize), spacing: gridSpacing), count: columns),
            spacing: gridSpacing
        ) {
            ForEach(accessories) { accessory in
                InventoryAccessorySquare(
                    accessory: accessory,
                    isEquipped: userProfileViewModel.profile.equippedAccessories.contains(accessory.name),
                    size: itemSize,
                    isOwnProfile: true,
                    profile: _userProfileViewModel
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(userProfileViewModel.profile.equippedAccessories.contains(accessory.name) ? Color("AppRed") : Color.clear, lineWidth: 1)
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
