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
        Achievement(id: UUID(), name: "Лоулайт", description: "Достигните 10.000 очков"),
        Achievement(id: UUID(), name: "Гений", description: "Достигните 13.000 очков"),
        Achievement(id: UUID(), name: "The Beatles", description: "Достигните 22.222 очков"),
        Achievement(id: UUID(), name: "genesius", description: "Достигните 30.000 очков"),
        Achievement(id: UUID(), name: "L", description: "Решите 10 задач"),
        Achievement(id: UUID(), name: "Топ", description: "Решите 100 задач"),
        Achievement(id: UUID(), name: "God", description: "Достигните 40000 очков")
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
                case "Гений":
                    if profile.profile.points >= 13000 {
                        profile.profile.achievements.append(achievement.name)
                        profile.saveProfile()
                    }
                case "The Beatles":
                    if profile.profile.points >= 22222 {
                        profile.profile.achievements.append(achievement.name)
                        profile.saveProfile()
                    }
                case "genesius":
                    if profile.profile.points >= 30000 {
                        profile.profile.achievements.append(achievement.name)
                        profile.saveProfile()
                    }
                case "L":
                    if profile.profile.completedTasks.count >= 10 {
                        profile.profile.achievements.append(achievement.name)
                        profile.saveProfile()
                    }
                case "Топ":
                    if profile.profile.completedTasks.count >= 100 {
                        profile.profile.achievements.append(achievement.name)
                        profile.saveProfile()
                    }
                case "God":
                    if profile.profile.points >= 40000 {
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
