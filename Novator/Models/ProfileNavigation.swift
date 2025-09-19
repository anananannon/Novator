import Foundation
import SwiftUI

struct ProfileNavigationItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let imageSize: CGFloat
    let destinationType: DestinationType

    enum DestinationType {
        case myprofile
        case settings
        case statistics
        case store
        case inventory
        case friends
        case chats
        case privacy
        case connectedDevices
        case downloadedFiles
        case help
    }
}

enum ProfileNavigation {
    static let section0: [ProfileNavigationItem] = [
        ProfileNavigationItem(title: "Мой профиль", imageName: /*"person.crop.square"*/ "person.crop.circle", imageSize: 24, destinationType: .myprofile)
    ]
    
    static let section1: [ProfileNavigationItem] = [
        ProfileNavigationItem(title: "Магазин", imageName: "gift.fill", imageSize: 21, destinationType: .store),
        ProfileNavigationItem(title: "Инвентарь", imageName: "square.grid.2x2.fill", imageSize: 21, destinationType: .inventory)
    ]
    
    static let section2: [ProfileNavigationItem] = [
        ProfileNavigationItem(title: "Друзья", imageName: "person.2.crop.square.stack.fill", imageSize: 22.6, destinationType: .friends),
        ProfileNavigationItem(title: "Чаты", imageName: "envelope.fill", imageSize: 17, destinationType: .chats)
    ]
    
    static let section3: [ProfileNavigationItem] = [
        ProfileNavigationItem(title: "Статистика", imageName: "chart.bar.xaxis", imageSize: 18, destinationType: .statistics),
        ProfileNavigationItem(title: "Конфиденциальность", imageName: "lock.square", imageSize: 21, destinationType: .privacy),
        ProfileNavigationItem(title: "Подключенные устройства", imageName: "macbook.and.ipad", imageSize: 14.7, destinationType: .connectedDevices),
        ProfileNavigationItem(title: "Настройки", imageName: "slider.horizontal.2.square", imageSize: 21, destinationType: .settings),
    ]
    
    static let section4: [ProfileNavigationItem] = [
        ProfileNavigationItem(title: "Помощь", imageName: "questionmark.app.fill", imageSize:21, destinationType: .help)
    ]
}

extension ProfileNavigationItem.DestinationType {
    var title: String {
        switch self {
        case .myprofile: return "Мой профиль"
        case .settings: return "Настройки"
        case .statistics: return "Статистика"
        case .store: return "Магазин"
        case .inventory: return "Инвентарь"
        case .friends: return "Друзья"
        case .chats: return "Чаты"
        case .privacy: return "Конфиденциальность"
        case .connectedDevices: return "Подключенные устройства"
        case .downloadedFiles: return "Скачанные файлы"
        case .help: return "Помощь"
        }
    }
}
