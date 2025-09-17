import SwiftUI

class NotificationManager: ObservableObject {
    @Published var notifications: [Notification] = []

    func addNotification(for achievement: Achievement) {
        let notification = Notification(
            title: "\(achievement.name)",
            message: "\(achievement.description)",
            icon: achievement.icon,
            timestamp: Date()
        )
        withAnimation(.spring(response: 0.3)) {
            notifications.append(notification)
        }
        
        // Удаляем уведомление через 5 секунд с анимацией
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            withAnimation(.spring(response: 0.3)) {
                self?.notifications.removeAll { $0.id == notification.id }
            }
        }
    }

    func clearNotifications() {
        withAnimation(.spring(response: 0.3)) {
            notifications.removeAll()
        }
    }
}
