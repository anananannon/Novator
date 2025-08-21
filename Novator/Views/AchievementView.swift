import SwiftUI

// MARK: - AchievementsView
struct AchievementsView: View {
    @ObservedObject var profile: UserProfileViewModel

    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Достижения").font(.subheadlineRounded)) {
                    ForEach(AchievementManager.achievements) { achievement in
                        HStack {
                            Image(systemName: profile.profile.achievements.contains(achievement.name) ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 24))
                                .foregroundColor(Color("AppRed"))
                            VStack(alignment: .leading, spacing: 4) {
                                Text(achievement.name)
                                    .font(.bodyRounded)
                                    .foregroundColor(.primary)
                                Text(achievement.description)
                                    .font(.subheadlineRounded)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Достижения")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(profile.theme.colorScheme)
    }
}

// MARK: - Preview
struct AchievementsView_Previews: PreviewProvider {
    static var previews: some View {
        AchievementsView(profile: UserProfileViewModel())
    }
}
