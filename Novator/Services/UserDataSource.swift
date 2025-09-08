import Foundation

protocol UserDataSourceProtocol {
    func getDemoUsers() -> [UserProfile]
    func getDemoFriends() -> [UserProfile]
}

class UserDataSource: UserDataSourceProtocol {
    func getDemoUsers() -> [UserProfile] {
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
                friends: [],
                pendingFriendRequests: [],
                completedTasks: [],
                achievements: ["Test", "Test2", "Test3"],
                completedLessons: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
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
                friends: [],
                pendingFriendRequests: [],
                completedTasks: [],
                achievements: []
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
                friends: [],
                pendingFriendRequests: [],
                completedTasks: [],
                achievements: []
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
                achievements: []
            )
        ]
    }

    func getDemoFriends() -> [UserProfile] {
        // В данном случае возвращаем пустой массив, но можно добавить логику для друзей
        return []
    }
}
