import Foundation
import SwiftUI
import Combine

final class FriendsViewModel: ObservableObject {
    // MARK: - Input
    @Published var profile: UserProfileViewModel? // Изменено на @Published для реактивности
    @Published var searchQuery = "" // Новый: для поиска по username

    // MARK: - Output
    @Published var friends: [UserProfile] = []
    // Computed: фильтрованные друзья по поиску
    var filteredFriends: [UserProfile] {
        if searchQuery.isEmpty {
            return friends
        }
        return friends.filter { user in
            user.username.localizedCaseInsensitiveContains(searchQuery) ||
            user.fullName.localizedCaseInsensitiveContains(searchQuery) // Бонус: поиск по имени тоже
        }
    }

    private let userDataSource: UserDataSourceProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Инициализация
    init(profile: UserProfileViewModel?, userDataSource: UserDataSourceProtocol = UserDataSource()) {
        self.profile = profile
        self.userDataSource = userDataSource
        if profile != nil {
            setupFriends()
        }
        bindProfile()
    }

    // MARK: - Приватные методы
    func setupFriends() {
        guard let profile = profile else {
            print("⚠️ FriendsViewModel: profile не установлен, пропускаем setupFriends")
            return
        }
        self.friends = userDataSource.getDemoFriends(friendIds: profile.profile.friends)
        print("🆕 FriendsViewModel: setupFriends с друзьями: \(friends.map { $0.id })")
    }

    private func bindProfile() {
        $profile
            .sink { [weak self] newProfile in
                guard let self = self, let profile = newProfile else { return }
                // Подписываемся на изменения profile.profile при установке нового profile
                profile.$profile
                    .sink { [weak self] newProfile in
                        guard let self = self else { return }
                        self.friends = self.userDataSource.getDemoFriends(friendIds: newProfile.friends)
                        self.objectWillChange.send()
                        print("🔔 FriendsViewModel: список друзей обновлен: \(self.friends.map { $0.id })")
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
}
