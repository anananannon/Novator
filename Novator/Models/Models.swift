import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    let category: String // "math" или "logic"
    let level: String // "beginner", "intermediate", "advanced"
    let question: String
    let options: [String]?
    let correctAnswer: String
    let explanation: String
}

struct UserProfile: Codable {
    var name: String
    var level: String // "beginner", "intermediate", "advanced"
    var points: Int
    var completedTasks: [UUID] // ID решенных задач
    var achievements: [String] // ID достижений
}

struct Achievement: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
}

class TaskManager {
    static func loadTasks() -> [Task] {
        guard let url = Bundle.main.url(forResource: "tasks", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let tasks = try? JSONDecoder().decode([Task].self, from: data) else {
            return []
        }
        return tasks
    }
}

class AchievementManager {
    static let achievements: [Achievement] = [
        Achievement(id: "novice", name: "Новичок", description: "Наберите 10 очков"),
        Achievement(id: "master", name: "Мастер", description: "Наберите 50 очков"),
        Achievement(id: "task10", name: "Решатель", description: "Решите 10 задач")
    ]

    static func checkAchievements(for profile: UserProfileViewModel) {
        for achievement in achievements {
            if !profile.profile.achievements.contains(achievement.id) {
                let shouldUnlock = checkCondition(for: achievement, profile: profile.profile)
                if shouldUnlock {
                    profile.profile.achievements.append(achievement.id)
                    profile.saveProfile()
                }
            }
        }
    }

    private static func checkCondition(for achievement: Achievement, profile: UserProfile) -> Bool {
        switch achievement.id {
        case "novice":
            return profile.points >= 10
        case "master":
            return profile.points >= 50
        case "task10":
            return profile.completedTasks.count >= 10
        default:
            return false
        }
    }
}
