import SwiftUI

struct ProfileLookView: View {
    let user: UserProfile

    let gridSpacing: CGFloat = 7
    let sidePadding: CGFloat = 17
    let columns = 3

    private var itemSize: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (screenWidth - sidePadding * 2 - gridSpacing * CGFloat(columns - 1)) / CGFloat(columns)
    }

    private var unlockedAchievements: [Achievement] {
        AchievementManager.achievements.filter { user.achievements.contains($0.name) }
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 0) {

                        // Анимация для аватара и полного имени
                        GeometryReader { proxy in
                            let offset = proxy.frame(in: .global).minY
                            let startOffset = geometry.frame(in: .global).minY
                            let maxOffset: CGFloat = 120
                            let relativeOffset = offset - startOffset
                            let scrollProgress = relativeOffset / maxOffset
                            let scale = max(0.7, min(1.1, 1 + scrollProgress * 0.2))

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
                            .animation(.linear, value: relativeOffset)
                            .frame(maxWidth: .infinity)
                        }
                        .frame(height: 140)
                        .padding(.top, 30)

                        
                        HStack {
                            Button {
                                
                            } label: {
                                VStack(spacing: 5) {
                                    Image(systemName: "person.fill.badge.plus")
                                        .font(.system(size: 21))
                                    Text("Добавить")
                                        .font(.system(size: 11))
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 70)
                                .background(Color("SectionBackground"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            
                            Button {
                                
                            } label: {
                                VStack(spacing: 5) {
                                    
                                    Image(systemName: "message.fill")
                                        .font(.system(size: 19))
                                    
                                    Text("Чат")
                                        .font(.system(size: 11))
                                    
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 70)
                                .background(Color("SectionBackground"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                        .padding(.horizontal, sidePadding)
                        .padding(.top, 14)
                        
                        // Остальная часть профиля
                        VStack {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("имя пользователя")
                                        .font(.system(size: 13))

                                    Text(user.username)
                                        .font(.system(size: 14))
                                        .fontWeight(.semibold)
                                        .foregroundColor(Color("AppRed"))
                                }
                                Spacer()
                            }
                            .padding()
                            .background(Color("SectionBackground"))
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(.horizontal, sidePadding)
                        .padding(.vertical, 14)

                        // Достижения
                        LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders]) {
                            if unlockedAchievements.count > 0 {
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
                                    }.padding(.horizontal, sidePadding)
                                }
                            }
                        }

                        Spacer()
                    }

                }
            }
            .background(Color("ProfileBackground"))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ProfileLookView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileLookView(user: UserProfile(
            firstName: "Павел",
            lastName: "Дуров",
            username: "@monk",
            avatar: nil,
            stars: 2131212,
            raitingPoints: 120041,
            streak: 5,
            friendsCount: 10,
            completedTasks: [],
            achievements: []
        ))
    }
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
    .background(Color("SectionBackground")) }
