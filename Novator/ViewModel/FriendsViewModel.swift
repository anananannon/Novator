import SwiftUI
import Combine

final class FriendsViewModel: ObservableObject {
    // MARK: - Input
    @ObservedObject var profile: UserProfileViewModel

    // MARK: - Output
    @Published var friends: [UserProfile] = []

    private let userDataSource: UserDataSourceProtocol
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Инициализация
    init(profile: UserProfileViewModel, userDataSource: UserDataSourceProtocol = UserDataSource()) {
        self.profile = profile
        self.userDataSource = userDataSource
        setupFriends()
        bindProfile()
    }

    // MARK: - Приватные методы
    func setupFriends() {
        self.friends = userDataSource.getDemoFriends(friendIds: profile.profile.friends)
        print("🆕 FriendsViewModel: setupFriends с друзьями: \(friends.map { $0.id })")
    }

    private func bindProfile() {
        profile.$profile
            .sink { [weak self] newProfile in
                guard let self = self else { return }
                self.friends = self.userDataSource.getDemoFriends(friendIds: newProfile.friends)
                print("🔔 FriendsViewModel: список друзей обновлен: \(self.friends.map { $0.id })")
            }
            .store(in: &cancellables)
    }
}
