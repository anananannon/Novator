import SwiftUI

struct ProfileLookView: View {
    let user: UserProfile
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
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    // MARK: - Аватар с анимацией
                    TopProfileHeader(user: user)

                    // MARK: - Действия
                    actionButtons

                    // MARK: - Инфо о пользователе
                    userInfo

                    // MARK: - Достижения
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
        }
    }

    // MARK: - Buttons
    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button {
                // add friend action
            } label: {
                VStack(spacing: 5) {
                    Image(systemName: "person.fill.badge.plus")
                        .font(.system(size: 21))
                    Text("Добавить").font(.system(size: 11))
                }
                .frame(maxWidth: .infinity, minHeight: 70)
                .background(Color("SectionBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Button {
                // chat action
            } label: {
                VStack(spacing: 5) {
                    Image(systemName: "message.fill")
                        .font(.system(size: 19))
                    Text("Чат").font(.system(size: 11))
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
            .padding(.horizontal, sidePadding)
        }
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

            VStack(spacing: 10) {
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
            }
            .scaleEffect(scale)
            .frame(maxWidth: .infinity)
        }
        .frame(height: 140)
        .padding(.top, 30)
    }
}
