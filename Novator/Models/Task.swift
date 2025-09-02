import Foundation
struct Task: Codable, Identifiable, Hashable {
    let id: UUID
    let category: String
    let question: String
    let options: [String]?
    let correctAnswer: String
    let explanation: String
    let points: Int
    let isLogicalTrick: Bool
}
