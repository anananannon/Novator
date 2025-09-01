import Foundation

struct Achievement: Codable, Identifiable {
    let id: UUID
    let icon: String
    let name: String
    let description: String
}

struct AchievementManager {
    static let achievements: [Achievement] = [
        Achievement(id: UUID(), icon: "figure.walk", name: "Начало пути", description: "Решите 5 задач"),
        Achievement(id: UUID(), icon: "bag.fill", name: "Накопитель", description: "Достигните 100 очков"),
        Achievement(id: UUID(), icon: "backpack", name: "5 класс", description: "Достигните 300 очков"),
        Achievement(id: UUID(), icon: "trophy", name: "Мастер", description: "Достигните 1.000 очков"),
        Achievement(id: UUID(), icon: "function", name: "Эйнштейн", description: "Решите 100 задач"),
        Achievement(id: UUID(), icon: "person", name: "Test", description: "Пройди 3 уровня")
        
    ]

    static func checkAchievements(for profile: UserProfileViewModel) {
        for achievement in achievements {
            if !profile.profile.achievements.contains(achievement.name) {
                switch achievement.name {
                case "Начало пути":
                    if profile.profile.completedTasks.count >= 5 {
                        profile.profile.achievements.append(achievement.name)
                        profile.saveProfile()
                    }
                case "Накопитель":
                    if profile.profile.points >= 100 {
                        profile.profile.achievements.append(achievement.name)
                        profile.saveProfile()
                    }
                case "5 класс":
                    if profile.profile.points >= 300 {
                        profile.profile.achievements.append(achievement.name)
                        profile.saveProfile()
                    }
                case "Мастер":
                    if profile.profile.points >= 1000 {
                        profile.profile.achievements.append(achievement.name)
                        profile.saveProfile()
                    }
                case "Эйнштейн":
                    if profile.profile.completedTasks.count >= 100 {
                        profile.profile.achievements.append(achievement.name)
                        profile.saveProfile()
                    }
                case "Test":
                    if profile.profile.completedLessons.count >= 3 {
                        profile.profile.achievements.append(achievement.name)
                        profile.saveProfile()
                    }
                default:
                    break
                }
            }
        }
    }
}
