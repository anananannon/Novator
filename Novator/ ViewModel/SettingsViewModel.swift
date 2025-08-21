import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var selectedTheme: UserProfileViewModel.Theme
    @Published var notificationsEnabled: Bool
    private let profile: UserProfileViewModel

    init(profile: UserProfileViewModel) {
        self.profile = profile
        self.selectedTheme = profile.theme
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
    }

    func updateTheme(_ newTheme: UserProfileViewModel.Theme) {
        selectedTheme = newTheme
        profile.theme = newTheme
    }

    func toggleNotifications(_ enabled: Bool) {
        notificationsEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: "notificationsEnabled")
    }
}
