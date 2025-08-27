import Foundation

struct Achievement: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String
}

struct AchievementManager {
    static let achievements: [Achievement] = [
        Achievement(id: UUID(), name: "Ученик", description: "Решите 5 задач"),
        Achievement(id: UUID(), name: "Накопитель", description: "Достигните 100 очков"),
        Achievement(id: UUID(), name: "5 класс", description: "Достигните 300 очков"),
        Achievement(id: UUID(), name: "Мастер", description: "Достигните 1.000 очков"),
        Achievement(id: UUID(), name: "Эйнштейн", description: "Решите 100 задач")
    ]

    static func checkAchievements(for profile: UserProfileViewModel) {
        for achievement in achievements {
            if !profile.profile.achievements.contains(achievement.name) {
                switch achievement.name {
                case "Ученик":
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
                default:
                    break
                }
            }
        }
    }
}
