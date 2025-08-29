import Foundation


enum TaskType {
    case multipleChoice    // обычный выбор ответа
    case calculation       // пользователь вводит число
    case formula           // пользователь вводит выражение
    case trueFalse          // логические утверждения
}


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
