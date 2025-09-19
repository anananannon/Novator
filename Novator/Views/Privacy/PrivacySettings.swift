import Foundation

struct PrivacySettings: Codable {
    var showAchievements: Bool
    var showAccessories: Bool  // Новое: для аксессуаров
    var showFriendsList: Bool
    var showStatistics: Bool
    
    // Инициализатор с параметрами и значениями по умолчанию
    init(showAchievements: Bool = true,
         showAccessories: Bool = true,  // Новое: по умолчанию видно
         showFriendsList: Bool = true,
         showStatistics: Bool = true) {
        self.showAchievements = showAchievements
        self.showAccessories = showAccessories
        self.showFriendsList = showFriendsList
        self.showStatistics = showStatistics
    }
    
    // Метод для сброса
    mutating func resetToDefaults() {
        self = PrivacySettings()
    }
}
