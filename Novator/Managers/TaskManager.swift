import Foundation

struct LearningProgram {
    let tasks: [Task]
    let level: String
    var currentIndex: Int
    
    init(tasks: [Task], level: String) {
        self.tasks = tasks.sorted { $0.points < $1.points }
        self.level = level
        self.currentIndex = 0
        print("LearningProgram: Level \(level), \(tasks.count) tasks available")
    }
    
    var currentTask: Task? {
        currentIndex < tasks.count ? tasks[currentIndex] : nil
    }
    
    mutating func nextTask() -> Task? {
        currentIndex += 1
        return currentTask
    }
}

class TaskManager {
    static let tasks: [Task] = {
        guard let url = Bundle.main.url(forResource: "tasks", withExtension: "json") else {
            print("Error: tasks.json not found in Bundle")
            return [
                Task(id: UUID(), category: "math", level: "beginner", question: "2 + 2 = ?", options: ["3", "4", "5", "6"], correctAnswer: "4", explanation: "2 + 2 = 4", points: 10, isLogicalTrick: false),
                Task(id: UUID(), category: "logic", level: "beginner", question: "Какой день после понедельника?", options: ["Вторник", "Среда", "Четверг"], correctAnswer: "Вторник", explanation: "После понедельника идёт вторник.", points: 10, isLogicalTrick: true)
            ]
        }
        guard let data = try? Data(contentsOf: url) else {
            print("Error: Failed to read tasks.json")
            return [
                Task(id: UUID(), category: "math", level: "beginner", question: "2 + 2 = ?", options: ["3", "4", "5", "6"], correctAnswer: "4", explanation: "2 + 2 = 4", points: 10, isLogicalTrick: false),
                Task(id: UUID(), category: "logic", level: "beginner", question: "Какой день после понедельника?", options: ["Вторник", "Среда", "Четверг"], correctAnswer: "Вторник", explanation: "После понедельника идёт вторник.", points: 10, isLogicalTrick: true)
            ]
        }
        guard let tasks = try? JSONDecoder().decode([Task].self, from: data) else {
            print("Error: Failed to decode tasks.json")
            return [
                Task(id: UUID(), category: "math", level: "beginner", question: "2 + 2 = ?", options: ["3", "4", "5", "6"], correctAnswer: "4", explanation: "2 + 2 = 4", points: 10, isLogicalTrick: false),
                Task(id: UUID(), category: "logic", level: "beginner", question: "Какой день после понедельника?", options: ["Вторник", "Среда", "Четверг"], correctAnswer: "Вторник", explanation: "После понедельника идёт вторник.", points: 10, isLogicalTrick: true)
            ]
        }
        print("TaskManager: Loaded \(tasks.count) tasks from tasks.json")
        return tasks
    }()
    
    static func createLearningProgram(for level: String, completedTasks: [UUID]) -> LearningProgram {
        let normalizedLevel = level.lowercased()
        let filteredTasks = tasks.filter { $0.level.lowercased() == normalizedLevel && !completedTasks.contains($0.id) }
        print("TaskManager: Creating LearningProgram for level: \(normalizedLevel), Available tasks: \(filteredTasks.count)")
        if filteredTasks.isEmpty {
            print("TaskManager: No tasks for level \(normalizedLevel), falling back to beginner tasks")
            return LearningProgram(tasks: tasks.filter { $0.level == "beginner" }, level: normalizedLevel)
        }
        return LearningProgram(tasks: filteredTasks, level: normalizedLevel)
    }
}
