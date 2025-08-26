import SwiftUI

// MARK: - AchievementsView
struct AchievementsView: View {
    @ObservedObject var profile: UserProfileViewModel

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
        List {
            Section() {
                ForEach(AchievementManager.achievements) { achievement in
                    AchievementRow(
                        achievement: achievement,
                        isUnlocked: profile.profile.achievements.contains(achievement.name)
                    )
                    .listRowSeparator(.hidden)
                }
            }
        }
        .listStyle(.inset)
    }
}

// MARK: - Subviews
private extension AchievementsView {
    func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.subheadlineRounded)
            .foregroundColor(.secondary)
    }
}

// MARK: - Preview
struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView(profile: UserProfileViewModel())
    }
}
