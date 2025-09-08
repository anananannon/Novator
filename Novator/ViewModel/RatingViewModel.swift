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
    private let userDataSource: UserDataSourceProtocol

    // MARK: - Инициализация
    init(profile: UserProfileViewModel, userDataSource: UserDataSourceProtocol = UserDataSource()) {
        self.profile = profile
        self.userDataSource = userDataSource
        setupData()
        bindProfile()
    }

    // MARK: - Приватные методы
    private func setupData() {
        self.users = userDataSource.getDemoUsers()
        self.friends = userDataSource.getDemoFriends()
        print("🆕 RatingViewModel: setupData с пользователями: \(users.map { $0.id })")
    }

    private func bindProfile() {
        profile.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
