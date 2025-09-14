import SwiftUI
import Combine

// MARK: - AchievementsView
struct AchievementsView: View {
    @ObservedObject var profile: UserProfileViewModel
    @StateObject private var viewModel: AchievementsViewModel

    private let gridSpacing: CGFloat = 7
    private let sidePadding: CGFloat = 12
    private let columns = 3

    // MARK: - Инициализация
    init(profile: UserProfileViewModel) {
        self.profile = profile
        _viewModel = StateObject(wrappedValue: AchievementsViewModel(profile: profile))
    }

    private var itemSize: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return (screenWidth - sidePadding * 2 - gridSpacing * CGFloat(columns - 1)) / CGFloat(columns)
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack {
                Color("ProfileBackground")
                    .ignoresSafeArea()

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16, pinnedViews: [.sectionHeaders]) {
                        if !viewModel.unlockedAchievements.isEmpty {
                            Section(header: sectionHeader(title: "ВАШИ")) {
                                achievementsGrid(viewModel.unlockedAchievements, unlocked: true)
                            }
                        }

                        if !viewModel.lockedAchievements.isEmpty {
                            Section(header: sectionHeader(title: "НЕ ПОЛУЧЕНО")) {
                                achievementsGrid(viewModel.lockedAchievements, unlocked: false)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .navigationTitle("Достижения")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(profile.theme.colorScheme)
        }
    }

    // MARK: - Grid генератор
    private func achievementsGrid(_ achievements: [Achievement], unlocked: Bool) -> some View {
        LazyVGrid(
            columns: Array(repeating: GridItem(.fixed(itemSize), spacing: gridSpacing), count: columns),
            spacing: gridSpacing
        ) {
            ForEach(achievements) { achievement in
                AchievementSquare(
                    achievement: achievement,
                    isUnlocked: unlocked,
                    size: itemSize
                )
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
