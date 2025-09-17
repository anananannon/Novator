import SwiftUI

struct Notification: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let message: String
    let icon: String
    let timestamp: Date

    static func == (lhs: Notification, rhs: Notification) -> Bool {
        lhs.id == rhs.id
    }
}
