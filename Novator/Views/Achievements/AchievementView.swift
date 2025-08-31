import SwiftUI

// MARK: - AchievementsView
struct AchievementsView: View {
    @ObservedObject var profile: UserProfileViewModel
    
    let gridSpacing: CGFloat = 7
    let sidePadding: CGFloat = 10
    let columns = 3
    
    // computed property для размера карточки
    private var itemSize: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (screenWidth - sidePadding * 2 - gridSpacing * CGFloat(columns - 1)) / CGFloat(columns)
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Достижения")
                .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(profile.theme.colorScheme)
    }
}

// MARK: - Content
private extension AchievementsView {
    var content: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // MARK: - Раздел "ВАШИ"
                if unlockedAchievements.count > 0 {
                    Text("ВАШИ")
                        .font(.system(.subheadline, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 17)
                    
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
                
                // MARK: - Раздел "НЕ ПОЛУЧЕНО"
                if lockedAchievements.count > 0 {
                    Text("НЕ ПОЛУЧЕНО")
                        .font(.system(.subheadline, weight: .semibold))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 17)
                    
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.fixed(itemSize), spacing: gridSpacing), count: columns),
                        spacing: gridSpacing
                    ) {
                        ForEach(lockedAchievements) { achievement in
                            AchievementSquare(
                                achievement: achievement,
                                isUnlocked: false,
                                size: itemSize
                            )
                        }
                    }
                    .padding(.horizontal, sidePadding)
                }
            }
            .padding(.top, 10)
        }
    }
    
    // MARK: - Computed Properties
    private var unlockedAchievements: [Achievement] {
        AchievementManager.achievements.filter { profile.profile.achievements.contains($0.name) }
    }
    
    private var lockedAchievements: [Achievement] {
        AchievementManager.achievements.filter { !profile.profile.achievements.contains($0.name) }
    }
}

// MARK: - Preview
struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView(profile: UserProfileViewModel())
    }
}
