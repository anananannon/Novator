import SwiftUI

struct StoreView: View {
    
    @ObservedObject var profile: UserProfileViewModel
    @State private var showPopover = false

    private let gridSpacing: CGFloat = 7
    private let sidePadding: CGFloat = 12
    private let columns = 3

    private var itemSize: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (screenWidth - sidePadding * 2 - gridSpacing * CGFloat(columns - 1)) / CGFloat(columns)
    }

    // Available for purchase: Not owned
    private var availableAccessories: [Accessory] {
        AccessoryManager.availableAccessories.filter { !profile.profile.inventory.contains($0.name) }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color("ProfileBackground").ignoresSafeArea()
                ScrollView {
                    LazyVStack(spacing: 16, pinnedViews: [.sectionHeaders]) {
                        if !availableAccessories.isEmpty {
                            Section(header: sectionHeader(title: "ДОСТУПНЫ ДЛЯ ПОКУПКИ")) {
                                accessoriesGrid(availableAccessories)
                            }
                        } else {
                            Text("Все аксессуары куплены!").foregroundColor(.secondary)
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Магазин")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(profile.theme.colorScheme)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showPopover.toggle()
                    } label: {
                        StatView(icon: "star.fill", value: "\(profile.profile.stars)")
                    }
                    .popover(isPresented: $showPopover) {
                        Text("Очки опыта - вы можете потратить их в магазине украшений профиля.")
                            .padding()
                            .foregroundColor(Color("AppRed"))
                            .frame(maxWidth: 210, minHeight: 90)
                            .presentationCompactAdaptation(.popover)
                    }
                }
            }
        }
    }

    private func accessoriesGrid(_ accessories: [Accessory]) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.fixed(itemSize), spacing: gridSpacing), count: columns),
            spacing: gridSpacing
        ) {
            ForEach(accessories) { accessory in
                AccessorySquare(
                    accessory: accessory,
                    profile: profile,
                    onBuy: { profile.buyAccessory(accessory) },
                    size: itemSize
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
