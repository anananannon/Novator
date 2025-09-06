import Foundation
struct Achievement: Codable, Identifiable {
    let id: UUID
    let icon: String
    let name: String
    let description: String
}
