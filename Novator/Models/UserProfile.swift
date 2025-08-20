import Foundation

struct UserProfile: Codable, Identifiable {
    let id: UUID
    var firstName: String
    var lastName: String
    var username: String
    var avatar: String
    var level: String
    var points: Int
    var streak: Int
    var friendsCount: Int
    var completedTasks: [UUID]
    var achievements: [String]
    
    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
    
    init(id: UUID = UUID(), firstName: String = "Имя", lastName: String = "", username: String = "@username", avatar: String = "person.circle", level: String = "beginner", points: Int = 0, streak: Int = 0, friendsCount: Int = 0, completedTasks: [UUID] = [], achievements: [String] = []) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.avatar = avatar
        self.level = level
        self.points = points
        self.streak = streak
        self.friendsCount = friendsCount
        self.completedTasks = completedTasks
        self.achievements = achievements
    }
}
