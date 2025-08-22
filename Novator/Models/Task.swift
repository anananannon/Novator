import Foundation

struct Task: Codable, Identifiable {
    let id: UUID
    let category: String
    let level: String
    let question: String
    let options: [String]?
    let correctAnswer: String
    let explanation: String
    let points: Int
    let isLogicalTrick: Bool
}
