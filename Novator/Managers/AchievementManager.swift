import Foundation

struct AchievementManager {
    static let achievements: [Achievement] = [
        Achievement(id: UUID(), icon: "figure.walk", name: "Начало пути", description: "Решите 5 задач"),
        Achievement(id: UUID(), icon: "bag.fill", name: "Накопитель", description: "Достигните 100 очков магазина"),
        Achievement(id: UUID(), icon: "backpack", name: "5 класс", description: "Достигните 300 очков магазина"),
        Achievement(id: UUID(), icon: "trophy", name: "Мастер", description: "Достигните 1.000 очков магазина"),
        Achievement(id: UUID(), icon: "function", name: "Почти эйнштейн", description: "Решите 50 задач"),
        Achievement(id: UUID(), icon: "function", name: "Эйнштейн", description: "Решите 100 задач"),
        Achievement(id: UUID(), icon: "person", name: "Test", description: "Пройди 3 уровня"),
        Achievement(id: UUID(), icon: "crown", name: "Test2", description: "Достигните 150 очков рейтинга"),
        Achievement(id: UUID(), icon: "globe", name: "Test3", description: "Пройди 15 уровней")
    ]

    typealias AchievementCheck = (UserProfile) -> Bool

    private static let achievementCriteria: [String: AchievementCheck] = [
        "Начало пути": { $0.completedTasks.count >= 5 },
        "Накопитель": { $0.stars >= 100 },
        "5 класс": { $0.stars >= 300 },
        "Мастер": { $0.stars >= 1000 },
        "Почти эйнштейн": { $0.completedTasks.count >= 50},
        "Эйнштейн": { $0.completedTasks.count >= 100 },
        "Test": { $0.completedLessons.count >= 3 },
        "Test2": { $0.raitingPoints >= 150 },
        "Test3" : { $0.completedLessons.count >= 15 }
    ]

    static func checkAchievements(for profile: UserProfileViewModel, notificationManager: NotificationManager) {
        for achievement in achievements {
            guard !profile.profile.achievements.contains(achievement.name),
                  let criteria = achievementCriteria[achievement.name],
                  criteria(profile.profile)
            else { continue }

            profile.profile.achievements.append(achievement.name)
            profile.saveProfile()
            notificationManager.addNotification(for: achievement) // Добавляем уведомление
        }
    }
}
