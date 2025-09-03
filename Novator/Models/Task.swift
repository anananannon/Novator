import Foundation
struct AppTask: Codable, Identifiable, Hashable {
    let id: UUID
    let category: String
    let question: String
    let options: [String]?
    let correctAnswer: String
    let explanation: String
    let stars: Int
    let raitingPoints: Int
    let isLogicalTrick: Bool
}
