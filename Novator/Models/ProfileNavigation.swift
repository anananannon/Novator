import Foundation
import SwiftUI

struct ProfileNavigationItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let imageSize: CGFloat
    let destinationType: DestinationType

    enum DestinationType {
        case settings
        case statistics
        case store
        case friends
        case chats
        case privacy
        case connectedDevices
        case downloadedFiles
    }
}

enum ProfileNavigation {
    static let section1: [ProfileNavigationItem] = [
        ProfileNavigationItem(title: "Статистика", imageName: "chart.bar.xaxis", imageSize: 18, destinationType: .statistics),
        ProfileNavigationItem(title: "Магазин", imageName: "gift.fill", imageSize: 21, destinationType: .store)
    ]
    
    static let section2: [ProfileNavigationItem] = [
        ProfileNavigationItem(title: "Друзья", imageName: "person.2.crop.square.stack.fill", imageSize: 22.6, destinationType: .friends),
        ProfileNavigationItem(title: "Чаты", imageName: "envelope.fill", imageSize: 17, destinationType: .chats)
    ]
    
    static let section3: [ProfileNavigationItem] = [
        ProfileNavigationItem(title: "Конфиденциальность", imageName: "lock.square", imageSize: 21, destinationType: .privacy),
        ProfileNavigationItem(title: "Подключенные устройства", imageName: "macbook.and.ipad", imageSize: 14.7, destinationType: .connectedDevices),
        ProfileNavigationItem(title: "Настройки", imageName: "slider.horizontal.2.square", imageSize: 21, destinationType: .settings),
        ProfileNavigationItem(title: "Скачанные файлы", imageName: "folder", imageSize: 18, destinationType: .downloadedFiles)
    ]
}

extension ProfileNavigationItem.DestinationType {
    var title: String {
        switch self {
        case .settings: return "Настройки"
        case .statistics: return "Статистика"
        case .store: return "Магазин"
        case .friends: return "Друзья"
        case .chats: return "Чаты"
        case .privacy: return "Конфиденциальность"
        case .connectedDevices: return "Подключенные устройства"
        case .downloadedFiles: return "Скачанные файлы"
        }
    }
}
