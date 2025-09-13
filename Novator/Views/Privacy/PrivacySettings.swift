import Foundation

struct PrivacySettings: Codable {
    var showAchievements: Bool
    var showFriendsList: Bool
    var showStatistics: Bool
    
    // Инициализатор с параметрами и значениями по умолчанию
    init(showAchievements: Bool = true,
         showFriendsList: Bool = true,
         showStatistics: Bool = true) {
        self.showAchievements = showAchievements
        self.showFriendsList = showFriendsList
        self.showStatistics = showStatistics
    }
    
    // Метод для сброса
    mutating func resetToDefaults() {
        self = PrivacySettings()
    }
}
