import Foundation

protocol UserDataSourceProtocol {
    func getDemoUsers() -> [UserProfile]
    func getDemoFriends(friendIds: [UUID]) -> [UserProfile]
    func updateUserProfile(_ profile: UserProfile)
    func searchUsers(by query: String) async throws -> [UserProfile] // Новый метод
}

class UserDataSource: UserDataSourceProtocol {
    private var demoUsers: [UserProfile] = [] // Храним пользователей в памяти

    init() {
        demoUsers = loadDemoUsers()
    }

    private func loadDemoUsers() -> [UserProfile] {
        // Фиксированные UUID для пользователей
        let pavelId = UUID(uuidString: "550E8400-E29B-41D4-A716-446655440000")!
        let elonId = UUID(uuidString: "550E8400-E29B-41D4-A716-446655440001")!
        let ivanId = UUID(uuidString: "550E8400-E29B-41D4-A716-446655440002")!
        let jackId = UUID(uuidString: "550E8400-E29B-41D4-A716-446655440003")!

        return [
            UserProfile(
                id: pavelId,
                firstName: "Павел",
                lastName: "Дуров",
                username: "@monk",
                avatar: nil,
                stars: 2131212,
                raitingPoints: 120041,
                streak: 5,
                friendsCount: 10,
                friends: [elonId, ivanId],
                pendingFriendRequests: [],
                completedTasks: [],
                achievements: ["Test", "Test2", "Test3"],
                completedLessons: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"],
                privacySettings: PrivacySettings(showAchievements: false)
            ),
            UserProfile(
                id: elonId,
                firstName: "Илон",
                lastName: "Маск",
                username: "@elonmusk",
                avatar: nil,
                stars: 1200,
                raitingPoints: 22709,
                streak: 3,
                friendsCount: 8,
                friends: [pavelId],
                pendingFriendRequests: [],
                completedTasks: [],
                achievements: ["Test", "Test2", "Test3"],
                completedLessons: ["1", "2", "3", "4", "5", "6"],
                privacySettings: PrivacySettings()
            ),
            UserProfile(
                id: ivanId,
                firstName: "Иван",
                lastName: "Сидоров",
                username: "@ivan",
                avatar: nil,
                stars: 10,
                raitingPoints: 910,
                streak: 7,
                friendsCount: 12,
                friends: [pavelId],
                pendingFriendRequests: [],
                completedTasks: [],
                achievements: [],
                completedLessons: [],
                privacySettings: PrivacySettings()
            ),
            UserProfile(
                id: jackId,
                firstName: "Джек",
                lastName: "Дорси",
                username: "@jack",
                avatar: nil,
                stars: 1200,
                raitingPoints: 2812,
                streak: 1,
                friendsCount: 5,
                friends: [],
                pendingFriendRequests: [],
                completedTasks: [],
                achievements: [],
                completedLessons: [],
                privacySettings: PrivacySettings()
            )
        ]
    }

    func getDemoUsers() -> [UserProfile] {
        return demoUsers
    }

    func getDemoFriends(friendIds: [UUID]) -> [UserProfile] {
        return demoUsers.filter { friendIds.contains($0.id) }
    }

    func updateUserProfile(_ profile: UserProfile) {
        if let index = demoUsers.firstIndex(where: { $0.id == profile.id }) {
            demoUsers[index] = profile
            print("✅ Профиль пользователя \(profile.id) обновлён в UserDataSource")
        } else {
            print("⚠️ Пользователь \(profile.id) не найден в UserDataSource")
        }
    }

    func searchUsers(by query: String) async throws -> [UserProfile] {
        guard !query.isEmpty else { return [] }
        return demoUsers.filter { user in
            user.username.localizedCaseInsensitiveContains(query) ||
            user.fullName.localizedCaseInsensitiveContains(query)
        }
    }
}
