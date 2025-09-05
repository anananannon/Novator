import SwiftUI

struct AchievementsView: View {
    @ObservedObject var profile: UserProfileViewModel
    
    let gridSpacing: CGFloat = 7
    let sidePadding: CGFloat = 12
    let columns = 3
    
    private var itemSize: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (screenWidth - sidePadding * 2 - gridSpacing * CGFloat(columns - 1)) / CGFloat(columns)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders]) {
                    
                    // MARK: - ВАШИ
                    if unlockedAchievements.count > 0 {
                        Section(header: sectionHeader(title: "ВАШИ")) {
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
                    
                    // MARK: - НЕ ПОЛУЧЕНО
                    if lockedAchievements.count > 0 {
                        Section(header: sectionHeader(title: "НЕ ПОЛУЧЕНО")) {
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
                }
                .padding(.top, 10)
            }
            .navigationTitle("Достижения")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(profile.theme.colorScheme)
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
        .background(Color("TaskBackground"))
    }
    
    // MARK: - Computed Properties
    private var unlockedAchievements: [Achievement] {
        AchievementManager.achievements.filter { profile.profile.achievements.contains($0.name) }
    }
    
    private var lockedAchievements: [Achievement] {
        AchievementManager.achievements.filter { !profile.profile.achievements.contains($0.name) }
    }
}
