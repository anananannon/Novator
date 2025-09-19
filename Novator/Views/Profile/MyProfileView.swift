import SwiftUI

struct MyProfileView: View {
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @State private var showStreakPopover = false
    
    @State private var selectedTab: Tab = .achievements
    
    enum Tab {
        case achievements
        case accessories
    }
    
    private let gridSpacing: CGFloat = 7
    private let sidePadding: CGFloat = 17
    private let columns = 3

    private var itemSize: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (screenWidth - sidePadding * 2 - gridSpacing * CGFloat(columns - 1)) / CGFloat(columns)
    }

    private var unlockedAchievements: [Achievement] {
        AchievementManager.achievements.filter { userProfileViewModel.profile.achievements.contains($0.name) }
    }

    private var allAccessories: [Accessory] {
        let accessories = userProfileViewModel.profile.inventory.compactMap { AccessoryManager.accessory(forName: $0) }
        return accessories.sorted { a, b in
            let aIsEquipped = userProfileViewModel.profile.equippedAccessories.contains(a.name)
            let bIsEquipped = userProfileViewModel.profile.equippedAccessories.contains(b.name)
            return aIsEquipped && !bIsEquipped
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                TopProfileHeader(user: userProfileViewModel.profile)
                userInfo
                tabSelector
                GridContentView(
                    selectedTab: selectedTab,
                    unlockedAchievements: unlockedAchievements,
                    allAccessories: allAccessories,
                    equippedAccessories: userProfileViewModel.profile.equippedAccessories,
                    showAchievements: true, // Всегда показываем достижения для своего профиля
                    showAccessories: true,  // Новое: всегда видно для своего профиля (грид)
                    itemSize: itemSize,
                    columns: columns,
                    gridSpacing: gridSpacing,
                    sidePadding: sidePadding,
                    isOwnProfile: true // Передаем, что это профиль текущего пользователя
                )
                Spacer()
            }
        }
        .background(Color("ProfileBackground"))
        .scrollIndicators(.hidden)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
    }

    // MARK: - User Info
    private var userInfo: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("имя пользователя").font(.system(size: 13))
                    Text(userProfileViewModel.profile.username)
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .foregroundColor(Color("AppRed"))
                }
                Spacer()
            }
            .padding()
            .background(Color("SectionBackground"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .contextMenu {
                Button {
                    UIPasteboard.general.string = userProfileViewModel.profile.username
                } label: {
                    Label("Скопировать", systemImage: "doc.on.doc")
                }
            }
        }
        .padding(.horizontal, sidePadding)
    }

    // MARK: - Tab Selector (Telegram Style)
    private var tabSelector: some View {
        HStack(spacing: 0) {
            Button {
                selectedTab = .achievements
            } label: {
                Text("Достижения")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(selectedTab == .achievements ? Color("AppRed") : .secondary)
                    .padding(.vertical, 11)
                    .frame(maxWidth: .infinity)
            }
            
            Button {
                selectedTab = .accessories
            } label: {
                Text("Аксессуары")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(selectedTab == .accessories ? Color("AppRed") : .secondary)
                    .padding(.vertical, 11)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, sidePadding)
        .background(
            RoundedRectangle(cornerRadius: 0)
                .fill(Color("SectionBackground"))
        )
    }

    // MARK: - Toolbar
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                showStreakPopover.toggle()
            } label: {
                StatView(icon: "flame.fill", value: "\(userProfileViewModel.profile.streak)")
            }
            .popover(isPresented: $showStreakPopover) {
                Text("Стрик - количество дней подряд, когда вы выполняли минимум один уровень.")
                    .padding(.all, 10)
                    .foregroundColor(Color("AppRed"))
                    .frame(maxWidth: 260, minHeight: 105)
                    .presentationCompactAdaptation(.popover)
            }
        }
    }
}

// MARK: - Grid Content View (обновлён: showAccessories только для грида, для своего профиля true)
private struct GridContentView: View {
    let selectedTab: MyProfileView.Tab
    let unlockedAchievements: [Achievement]
    let allAccessories: [Accessory]
    let equippedAccessories: [String]
    let showAchievements: Bool
    let showAccessories: Bool  // Для грида аксессуаров
    let itemSize: CGFloat
    let columns: Int
    let gridSpacing: CGFloat
    let sidePadding: CGFloat
    let isOwnProfile: Bool // Новый параметр

    @EnvironmentObject var profile: UserProfileViewModel

    var body: some View {
        Group {
            if selectedTab == .achievements {
                if showAchievements && !unlockedAchievements.isEmpty {
                    achievementsGrid
                } else if showAchievements {
                    emptyContentView(title: "Нет достижений")
                } else {
                    emptyContentView(title: "Достижения скрыты")
                }
            } else {
                if showAccessories && !allAccessories.isEmpty {
                    accessoriesGrid
                } else if showAccessories {
                    emptyContentView(title: "Инвентарь пуст")
                } else {
                    emptyContentView(title: "Аксессуары скрыты")
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: selectedTab)
    }

    private var achievementsGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.fixed(itemSize), spacing: gridSpacing), count: columns),
            spacing: gridSpacing
        ) {
            ForEach(unlockedAchievements) { achievement in
                AchievementSquare(
                    achievement: achievement,
                    isUnlocked: true,
                    size: itemSize
                )
            }
        }
        .padding(.horizontal, sidePadding)
    }

    private var accessoriesGrid: some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.fixed(itemSize), spacing: gridSpacing), count: columns),
            spacing: gridSpacing
        ) {
            ForEach(allAccessories) { accessory in
                InventoryAccessorySquare(
                    accessory: accessory,
                    isEquipped: equippedAccessories.contains(accessory.name),
                    size: itemSize,
                    isOwnProfile: isOwnProfile // Передаем параметр
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(equippedAccessories.contains(accessory.name) ? Color("AppRed") : Color.clear, lineWidth: 1)
                )
            }
        }
        .padding(.horizontal, sidePadding)
    }

    private func emptyContentView(title: String) -> some View {
        Text(title)
            .font(.system(size: 16))
            .foregroundColor(.secondary)
            .padding(.top, 20)
            .frame(maxWidth: .infinity)
    }
}

// MARK: - TopProfileHeader (дубликат для MyProfileView, обновлён аналогично)
private struct TopProfileHeader: View {
    let user: UserProfile
    private let maxScaleUp: CGFloat = 1.1
    private let minScaleDown: CGFloat = 0.7
    private let animationDistance: CGFloat = 120

    // Computed: Equipped accessories with details (всегда, без проверки privacy)
    private var equippedAccessoryDetails: [Accessory] {
        user.equippedAccessories.compactMap { AccessoryManager.accessory(forName: $0) }
    }

    var body: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .global).minY
            let offset = minY - 100

            // Вычисляем scale через замыкание
            let scale: CGFloat = {
                if offset > 0 {
                    let progressUp = min(offset / animationDistance, 1)
                    return 1.0 + (maxScaleUp - 1.0) * progressUp
                } else {
                    let progressDown = min(-offset / animationDistance, 1)
                    return 1.0 - (1.0 - minScaleDown) * progressDown
                }
            }()
            VStack(spacing: 5) {
                ZStack(alignment: .center) {
                    // Overlay equipped accessories in ZStack (stack them with fixed offsets for better positioning)
                    ForEach(Array(equippedAccessoryDetails.enumerated()), id: \.offset) { index, accessory in
                        Image(accessory.icon)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                    }
                    
                    // Avatar base
                    if let avatarData = user.avatar, let uiImage = UIImage(data: avatarData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color("AppRed"))
                    }
                }

                Text(user.fullName)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                Text("Уровень \(user.completedLessons.count)")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .scaleEffect(scale)
            .frame(maxWidth: .infinity)
        }
        .frame(height: 140)
        .padding(.top, 20)
        .padding(.bottom, 15)
    }
}
