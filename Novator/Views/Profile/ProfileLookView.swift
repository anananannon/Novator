import SwiftUI

struct ProfileLookView: View {
    let user: UserProfile
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    
    @State private var showStreakPopover = false
    @State private var showConfirmationDialog = false
    
    @State private var isFriendRequestSent = false // Отправка заявки
    @State private var isFriend = false // Статус друга
    @State private var hasIncomingRequest = false // Входящая заявка
    

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

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {
                TopProfileHeader(user: user)
                actionButtons
                userInfo
                if !unlockedAchievements.isEmpty {
                    Section(header: sectionHeader(title: "ДОСТИЖЕНИЯ")) {
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
                }
                Spacer()
            }
        }
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
            // Показываем кнопку только если это не собственный профиль
            if user.id != userProfileViewModel.profile.id {
                if hasIncomingRequest && !isFriend {
                    Button {
                        userProfileViewModel.acceptFriendRequest(from: user.id)
                        updateStates() // Обновляем состояния после принятия
                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName: "person.fill.checkmark")
                                .font(.system(size: 21))
                                .foregroundColor(Color("AppRed"))
                            Text("Принять заявку")
                                .foregroundColor(Color("AppRed"))
                                .font(.system(size: 11))
                        }
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .background(Color("SectionBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                } else {
                    Button {
                        if !isFriendRequestSent && !isFriend {
                            userProfileViewModel.sendFriendRequest(to: user.id)
                            isFriendRequestSent = true // Обновляем локально
                        }
                    } label: {
                        VStack(spacing: 5) {
                            Image(systemName: isFriend ? "person.fill" : isFriendRequestSent ? "person.fill.checkmark" : "person.fill.badge.plus")
                                .font(.system(size: 21))
                                .foregroundColor(isFriendRequestSent ? Color.gray : Color("AppRed"))
                            Text(isFriend ? "Ваш друг" : isFriendRequestSent ? "Заявка отправлена" : "Добавить")
                                .foregroundColor(isFriendRequestSent ? Color.gray : Color("AppRed"))
                                .font(.system(size: 11))
                        }
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .background(isFriend ? Color("SectionBackground") : isFriendRequestSent ? Color.gray.opacity(0.5) : Color("SectionBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(isFriend || isFriendRequestSent || hasIncomingRequest)
                    .contextMenu {
                        if isFriendRequestSent {
                            Button {
                                userProfileViewModel.cancelFriendRequest(to: user.id)
                                updateStates() // Обновляем состояния после отмены
                            } label: {
                                Label("Отклонить заявку", systemImage: "person.fill.xmark")
                            }
                        }
                        if isFriend {
                            Button {
                                showConfirmationDialog.toggle()
                            } label: {
                                Label("Удалить из друзей", systemImage: "person.fill.xmark")
                            }
                        }
                    }
                    .confirmationDialog(
                        Text("Вы точно хотите удалить этого человека из друзей?"),
                        isPresented: $showConfirmationDialog,
                        titleVisibility: .visible,
                        actions: {
                            Button("Удалить", role: .destructive) {
                                userProfileViewModel.removeFriend(user.id)
                                updateStates() // Обновляем состояния после удаления
                            }
                            Button("Отмена", role: .cancel) {}
                            
                        })
                }
            }

            Button {
                // chat action
            } label: {
                VStack(spacing: 5) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 19))
                        .foregroundColor(Color("AppRed"))
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

    // MARK: - Section Header
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

// MARK: - TopProfileHeader с увеличением при скролле вверх
private struct TopProfileHeader: View {
    let user: UserProfile
    private let maxScaleUp: CGFloat = 1.1
    private let minScaleDown: CGFloat = 0.7
    private let animationDistance: CGFloat = 120

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

private extension ProfileLookView {
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
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
