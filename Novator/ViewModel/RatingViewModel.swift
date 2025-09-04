import SwiftUI
import Combine

final class RatingViewModel: ObservableObject {
    // Подписка на изменения профиля пользователя
    @ObservedObject var profile: UserProfileViewModel

    // Списки пользователей и друзей
    @Published var users: [UserProfile] = []
    @Published var friends: [UserProfile] = []

    // Текущая вкладка Picker / TabView
    @Published var pickerMode: Int = 0

    // Отсортированный общий рейтинг
    var sortedUsers: [UserProfile] {
        ([profile.profile] + users).sorted { $0.raitingPoints > $1.raitingPoints }
    }

    // Отсортированный рейтинг друзей
    var sortedFriends: [UserProfile] {
        ([profile.profile] + friends).sorted { $0.raitingPoints > $1.raitingPoints }
    }

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Инициализация
    init(profile: UserProfileViewModel) {
        self.profile = profile

        // Пример данных для общего рейтинга
        self.users = [
            UserProfile(
                firstName: "Павел",
                lastName: "Дуров",
                username: "@monk",
                avatar: nil, // Changed to nil to match Data? type
                stars: 2131212,
                raitingPoints: 120041,
                streak: 5,
                friendsCount: 10,
                completedTasks: [],
                achievements: []
            ),
            UserProfile(
                firstName: "Илон",
                lastName: "Маск",
                username: "@elonmusk",
                avatar: nil, // Changed to nil to match Data? type
                stars: 1200,
                raitingPoints: 22709,
                streak: 3,
                friendsCount: 8,
                completedTasks: [],
                achievements: []
            ),
            UserProfile(
                firstName: "Иван",
                lastName: "Сидоров",
                username: "@ivan",
                avatar: nil, // Changed to nil to match Data? type
                stars: 10,
                raitingPoints: 910,
                streak: 7,
                friendsCount: 12,
                completedTasks: [],
                achievements: []
            ),
            UserProfile(
                firstName: "Джулия",
                lastName: "Вавилова",
                username: "@juli",
                avatar: nil, // Changed to nil to match Data? type
                stars: 701392,
                raitingPoints: 1923,
                streak: 7,
                friendsCount: 12,
                completedTasks: [],
                achievements: []
            ),
            UserProfile(
                firstName: "Джек",
                lastName: "Дорси",
                username: "@jack",
                avatar: nil, // Changed to nil to match Data? type
                stars: 1200,
                raitingPoints: 2812,
                streak: 1,
                friendsCount: 5,
                completedTasks: [],
                achievements: []
            )
        ]

        // В демо версии друзья пока только текущий профиль
        self.friends = []

        // Подписка на изменения в profile, чтобы обновлять RatingViewModel
        profile.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
