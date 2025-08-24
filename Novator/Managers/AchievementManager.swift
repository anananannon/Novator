import Foundation

struct Achievement: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String
}

struct AchievementManager {
    static let achievements: [Achievement] = [
        Achievement(id: UUID(), name: "Новичок", description: "Решите 1 задачу"),
        Achievement(id: UUID(), name: "Ученик", description: "Решите 5 задач"),
        Achievement(id: UUID(), name: "Мастер", description: "Достигните 50 очков"),
        Achievement(id: UUID(), name: "Лоулайт", description: "Достигните 10.000 очков")
    ]

    static func checkAchievements(for profile: UserProfileViewModel) {
        for achievement in achievements {
            if !profile.profile.achievements.contains(achievement.name) {
                switch achievement.name {
                case "Новичок":
                    if profile.profile.completedTasks.count >= 1 {
                        profile.profile.achievements.append(achievement.name)
                        profile.saveProfile()
                    }
                case "Ученик":
                    if profile.profile.completedTasks.count >= 5 {
                        profile.profile.achievements.append(achievement.name)
                        profile.saveProfile()
                    }
                case "Мастер":
                    if profile.profile.points >= 50 {
                        profile.profile.achievements.append(achievement.name)
                        profile.saveProfile()
                    }
                case "Лоулайт":
                    if profile.profile.points >= 10000 {
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
