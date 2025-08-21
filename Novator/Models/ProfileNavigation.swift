import Foundation
import SwiftUI

struct ProfileNavigationItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let imageSize: CGFloat
    let link: AnyView?

    init(title: String, imageName: String, imageSize: CGFloat, link: AnyView? = nil) {
        self.title = title
        self.imageName = imageName
        self.imageSize = imageSize
        self.link = link
    }
}

enum ProfileNavigation {
    static let section1: [ProfileNavigationItem] = [
        ProfileNavigationItem(title: "Статистика", imageName: "chart.bar.xaxis", imageSize: 18),
        ProfileNavigationItem(title: "Активность", imageName: "bolt.square", imageSize: 21)
    ]
    
    static let section2: [ProfileNavigationItem] = [
        ProfileNavigationItem(title: "Друзья", imageName: "person.2.crop.square.stack.fill", imageSize: 22.6),
        ProfileNavigationItem(title: "Чаты", imageName: "envelope.fill", imageSize: 17)
    ]
    
    static let section3: [ProfileNavigationItem] = [
        ProfileNavigationItem(title: "Конфиденциальность", imageName: "lock.square", imageSize: 21),
        ProfileNavigationItem(title: "Подключенные устройства", imageName: "macbook.and.ipad", imageSize: 14.7),
        ProfileNavigationItem(title: "Настройки", imageName: "slider.horizontal.2.square", imageSize: 21, link: AnyView(SettingsView(profile: UserProfileViewModel()))),
        ProfileNavigationItem(title: "Скачанные файлы", imageName: "folder", imageSize: 18)
    ]
}
