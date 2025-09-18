// AccessoryModel.swift (Новый файл)
import Foundation

struct Accessory: Codable, Identifiable {
    let id: UUID
    let icon: String // System name or custom image name
    let name: String
    let price: Int // Cost in stars
    let description: String?
    let category: AccessoryCategory // Optional: for filtering if needed
    
    enum AccessoryCategory: String, Codable, CaseIterable {
        case head = "Head"
        case body = "Body"
        case other = "Other"
    }
}
