import SwiftUI

struct ProfileLookView: View {
    let user: UserProfile
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    
    @State private var showStreakPopover = false
    @State private var showConfirmationDialog = false
    
    @State private var isFriendRequestSent = false // Отправка заявки
    @State private var isFriend = false // Статус друга
    @State private var hasIncomingRequest = false // Входящая заявка
    
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
        AchievementManager.achievements.filter { user.achievements.contains($0.name) }
    }

    private var allAccessories: [Accessory] {
        let accessories = user.inventory.compactMap { AccessoryManager.accessory(forName: $0) }
        return accessories.sorted { a, b in
            let aIsEquipped = user.equippedAccessories.contains(a.name)
            let bIsEquipped = user.equippedAccessories.contains(b.name)
            return aIsEquipped && !bIsEquipped
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                TopProfileHeader(user: user)
                actionButtons
                userInfo
                tabSelector
                GridContentView(
                    selectedTab: selectedTab,
                    unlockedAchievements: unlockedAchievements,
                    allAccessories: allAccessories,
                    equippedAccessories: user.equippedAccessories,
                    showAchievements: user.privacySettings.showAchievements,
                    itemSize: itemSize,
                    columns: columns,
                    gridSpacing: gridSpacing,
                    sidePadding: sidePadding,
                    isOwnProfile: false // Передаем, что это не профиль текущего пользователя
                )
                Spacer()
            }
        }
        .tint(Color("AppRed"))
        .background(Color("ProfileBackground"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .onAppear {
            updateStates()
        }
        .onReceive(userProfileViewModel.$profile) { newProfile in
            updateStates()
        }
    }

    // MARK: - Обновление состояний
    private func updateStates() {
        isFriendRequestSent = userProfileViewModel.profile.pendingFriendRequests.contains(user.id)
        isFriend = userProfileViewModel.profile.friends.contains(user.id)
        hasIncomingRequest = userProfileViewModel.profile.incomingFriendRequests.contains(user.id)
        print("🔔 ProfileLookView update: user.id = \(user.id), pendingFriendRequests = \(userProfileViewModel.profile.pendingFriendRequests), isFriendRequestSent = \(isFriendRequestSent), isFriend = \(isFriend), hasIncomingRequest = \(hasIncomingRequest)")
    }

    // MARK: - Buttons
    private var actionButtons: some View {
        HStack(spacing: 12) {
            // Единая кнопка для управления дружбой
            Button {
                if hasIncomingRequest && !isFriend {
                    userProfileViewModel.acceptFriendRequest(from: user.id)
                } else if isFriend {
                    showConfirmationDialog.toggle()
                } else if isFriendRequestSent {
                    userProfileViewModel.cancelFriendRequest(to: user.id)
                } else {
                    userProfileViewModel.sendFriendRequest(to: user.id)
                    isFriendRequestSent = true
                }
                updateStates()
            } label: {
                VStack(spacing: 5) {
                    HStack {
                        Spacer()
                        Image(systemName: friendButtonIcon)
                            .font(.system(size: 21))
                            .foregroundColor(friendButtonColor)
                            .contentTransition(.symbolEffect(.replace)) // Анимация смены символа
                        Spacer()
                    }
                    Text(friendButtonText)
                        .foregroundColor(friendButtonColor)
                        .font(.system(size: 11))
                }
                .frame(maxWidth: .infinity, minHeight: 70)
                .background(friendButtonBackground)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .disabled(hasIncomingRequest && isFriend)
            .confirmationDialog(
                "Вы точно хотите удалить этого человека из друзей?",
                isPresented: $showConfirmationDialog,
                titleVisibility: .visible,
                actions: {
                    Button("Удалить", role: .destructive) {
                        userProfileViewModel.removeFriend(user.id)
                        updateStates()
                    }
                    Button("Отмена", role: .cancel) {}
                }
            )

            // Кнопка чата
            Button {
                // Chat action
            } label: {
                VStack(spacing: 5) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 19))
                        .foregroundColor(Color("AppRed"))
                        .contentTransition(.symbolEffect(.replace))
                    Text("Чат")
                        .font(.system(size: 11))
                        .foregroundColor(Color("AppRed"))
                }
                .frame(maxWidth: .infinity, minHeight: 70)
                .background(Color("SectionBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .padding(.horizontal, sidePadding)
        .animation(.spring(response: 0.2), value: isFriend)
        .animation(.spring(response: 0.2), value: isFriendRequestSent)
        .animation(.spring(response: 0.2), value: hasIncomingRequest)
    }

    // Вычисляемые свойства для управления иконкой, текстом и цветом кнопки
    private var friendButtonIcon: String {
        if hasIncomingRequest && !isFriend {
            return "person.fill.checkmark"
        } else if isFriend {
            return "person.fill"
        } else if isFriendRequestSent {
            return "person.fill.checkmark"
        } else {
            return "person.fill.badge.plus"
        }
    }

    private var friendButtonText: String {
        if hasIncomingRequest && !isFriend {
            return "Принять заявку"
        } else if isFriend {
            return "Ваш друг"
        } else if isFriendRequestSent {
            return "Заявка отправлена"
        } else {
            return "Добавить"
        }
    }

    private var friendButtonColor: Color {
        if isFriendRequestSent {
            return Color.gray
        } else {
            return Color("AppRed")
        }
    }

    private var friendButtonBackground: Color {
        if isFriendRequestSent {
            return Color.gray.opacity(0.5)
        } else {
            return Color("SectionBackground")
        }
    }

    // MARK: - User Info
    private var userInfo: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("имя пользователя").font(.system(size: 13))
                    Text(user.username)
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
                    UIPasteboard.general.string = user.username
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
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(selectedTab == .achievements ? Color("AppRed") : .secondary)
                    .padding(.vertical, 11)
                    .frame(maxWidth: .infinity)
            }
            
            Button {
                selectedTab = .accessories
            } label: {
                Text("Аксессуары")
                    .font(.system(size: 14, weight: .medium))
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
                StatView(icon: "flame.fill", value: "\(user.streak)")
            }
            .popover(isPresented: $showStreakPopover) {
                Text("Стрик - количество дней подряд, когда пользователь выполнял минимум один уровень.")
                    .padding(.all, 10)
                    .foregroundColor(Color("AppRed"))
                    .frame(maxWidth: 260, minHeight: 105)
                    .presentationCompactAdaptation(.popover)
            }
        }
    }
}

// MARK: - Grid Content View
private struct GridContentView: View {
    let selectedTab: ProfileLookView.Tab
    let unlockedAchievements: [Achievement]
    let allAccessories: [Accessory]
    let equippedAccessories: [String]
    let showAchievements: Bool
    let itemSize: CGFloat
    let columns: Int
    let gridSpacing: CGFloat
    let sidePadding: CGFloat
    let isOwnProfile: Bool // Новый параметр для определения текущего пользователя

    @EnvironmentObject var profile: UserProfileViewModel

    var body: some View {
        Group {
            if selectedTab == .achievements {
                if showAchievements && !unlockedAchievements.isEmpty {
                    achievementsGrid
                } else if showAchievements {
                    emptyContentView(title: "Достижения")
                } else {
                    emptyContentView(title: "Достижения скрыты")
                }
            } else {
                if !allAccessories.isEmpty {
                    accessoriesGrid
                } else {
                    emptyContentView(title: "Нет аксессуаров")
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

// MARK: - TopProfileHeader
private struct TopProfileHeader: View {
    let user: UserProfile
    private let maxScaleUp: CGFloat = 1.1
    private let minScaleDown: CGFloat = 0.7
    private let animationDistance: CGFloat = 120

    // Computed: Equipped accessories with details
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
