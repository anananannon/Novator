import SwiftUI
import Combine

// MARK: - ViewModel рейтинга
final class RatingViewModel: ObservableObject {
    // MARK: - Input
    @ObservedObject var profile: UserProfileViewModel

    // MARK: - Output
    @Published var users: [UserProfile] = []
    @Published var friends: [UserProfile] = []
    @Published var pickerMode: Int = 0

    // MARK: - Сортировка
    var sortedUsers: [UserProfile] {
        ([profile.profile] + users).sorted { $0.raitingPoints > $1.raitingPoints }
    }

    var sortedFriends: [UserProfile] {
        ([profile.profile] + friends).sorted { $0.raitingPoints > $1.raitingPoints }
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Инициализация
    init(profile: UserProfileViewModel) {
        self.profile = profile
        setupDemoData()
        bindProfile()
    }

    // MARK: - Приватные методы
    private func setupDemoData() {
        // Фиксированные UUID для пользователей
        let pavelId = UUID(uuidString: "550E8400-E29B-41D4-A716-446655440000")!
        let elonId = UUID(uuidString: "550E8400-E29B-41D4-A716-446655440001")!
        let ivanId = UUID(uuidString: "550E8400-E29B-41D4-A716-446655440002")!
        let jackId = UUID(uuidString: "550E8400-E29B-41D4-A716-446655440003")!

        self.users = [
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
        self.friends = []
        print("🆕 RatingViewModel: setupDemoData с фиксированными UUID: \(users.map { $0.id })")
    }

    private func bindProfile() {
        profile.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
