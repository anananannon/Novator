import Foundation
struct UserProfile: Codable, Identifiable {
    let id: UUID
    var firstName: String
    var lastName: String
    var username: String
    var avatar: Data? // Changed from String to Data? for image storage
    var stars: Int
    var raitingPoints: Int
    var streak: Int
    var friendsCount: Int
    var friends: [UUID]
    var pendingFriendRequests: [UUID] // Исходящие заявки (кому вы отправили)
    var incomingFriendRequests: [UUID] // Входящие заявки (кто отправил вам)
    var completedTasks: [UUID]
    var achievements: [String]
    var completedLessons: [String]
    var privacySettings: PrivacySettings // Вложенная структура
    
    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }

    init(id: UUID = UUID(), firstName: String = "Имя", lastName: String = "", username: String = "@username", avatar: Data? = nil, stars: Int = 0, raitingPoints: Int = 0, streak: Int = 0, friendsCount: Int = 0, friends: [UUID] = [], pendingFriendRequests: [UUID] = [], incomingFriendRequests: [UUID] = [], completedTasks: [UUID] = [], achievements: [String] = [], completedLessons: [String] = [], privacySettings: PrivacySettings = PrivacySettings()) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.avatar = avatar
        self.stars = stars
        self.raitingPoints = raitingPoints
        self.streak = streak
        self.friendsCount = friendsCount
        self.friends = friends
        self.pendingFriendRequests = pendingFriendRequests
        self.incomingFriendRequests = incomingFriendRequests
        self.completedTasks = completedTasks
        self.achievements = achievements
        self.completedLessons = completedLessons
        self.privacySettings = privacySettings // Инициализация
    }
}
