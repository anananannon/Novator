import Foundation
import SwiftUI

// MARK: - ViewModel настроек
class SettingsViewModel: ObservableObject {
    // MARK: - Входные данные
    @Published var selectedTheme: UserProfileViewModel.Theme
    @Published var notificationsEnabled: Bool

    private let profile: UserProfileViewModel

    // MARK: - Инициализация
    init(profile: UserProfileViewModel) {
        self.profile = profile
        self.selectedTheme = profile.theme
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
    }

    // MARK: - Методы
    func updateTheme(_ newTheme: UserProfileViewModel.Theme) {
        selectedTheme = newTheme
        profile.theme = newTheme
    }

    func toggleNotifications(_ enabled: Bool) {
        notificationsEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: "notificationsEnabled")
    }
}
