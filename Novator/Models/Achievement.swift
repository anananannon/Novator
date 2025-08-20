import Foundation

struct Achievement: Codable, Identifiable {
    let id: UUID
    let name: String
    let description: String
}
