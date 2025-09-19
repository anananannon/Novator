// AccessoryManager.swift (Новый файл)
import Foundation

enum AccessoryManager {
    static let availableAccessories: [Accessory] = [
//        Accessory(
//            id: UUID(),
//            icon: "medal",
//            iconView: "medal",
//            name: "Медаль",
//            price: 50,
//            description: "Золотая медаль за достижения",
//            category: .other
//        ),
        Accessory(
            id: UUID(),
            icon: "yshki",
            iconView: "yshkiView",
            name: "Ушки",
            price: 0,
            description: "Пусть ваша аватарка будет слышать, а не только существовать.",
            category: .head
        )
//        Accessory(
//            id: UUID(),
//            icon: "transmission",
//            iconView: "transView",
//            name: "Антенна",
//            price: 75,
//            description: "Антенна для связи с космосом",
//            category: .head
//        ),
        // Add more as needed, e.g., Accessory(id: ..., icon: "rocketSV", ...) if "rocketSV" is a custom asset
    ]
    
    // Helper to get accessory by name
    static func accessory(forName name: String) -> Accessory? {
        availableAccessories.first { $0.name == name }
    }
}
