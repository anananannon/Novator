import SwiftUI

// MARK: - AchievementsView
struct AchievementsView: View {
    @ObservedObject var profile: UserProfileViewModel
    
    let gridSpacing: CGFloat = 7
    let sidePadding: CGFloat = 9
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
            LazyVGrid(
                columns: Array(repeating: GridItem(.fixed(itemSize), spacing: gridSpacing), count: columns),
                spacing: gridSpacing
            ) {
                ForEach(AchievementManager.achievements) { achievement in
                    AchievementSquare(
                        achievement: achievement,
                        isUnlocked: profile.profile.achievements.contains(achievement.name),
                        size: itemSize
                    )
                }
            }
            .padding(.horizontal, sidePadding)
        }
    }
}

// MARK: - Preview
struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView(profile: UserProfileViewModel())
    }
}
