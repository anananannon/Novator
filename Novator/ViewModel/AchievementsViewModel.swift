import Foundation
import Combine

final class AchievementsViewModel: ObservableObject {
    @Published var unlockedAchievements: [Achievement] = []
    @Published var lockedAchievements: [Achievement] = []
    private var cancellables = Set<AnyCancellable>()

    init(profile: UserProfileViewModel) {
        updateAchievements(from: profile.profile.achievements)
        // Подписываемся на изменения profile
        profile.$profile
            .sink { [weak self] newProfile in
                self?.updateAchievements(from: newProfile.achievements)
            }
            .store(in: &cancellables)
    }

    private func updateAchievements(from userAchievements: [String]) {
        unlockedAchievements = AchievementManager.achievements.filter { userAchievements.contains($0.name) }
        lockedAchievements = AchievementManager.achievements.filter { !userAchievements.contains($0.name) }
    }
}
