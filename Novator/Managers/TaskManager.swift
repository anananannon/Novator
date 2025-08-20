import Foundation

class TaskManager {
    static let tasks: [Task] = {
        guard let url = Bundle.main.url(forResource: "tasks", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let tasks = try? JSONDecoder().decode([Task].self, from: data) else {
            return []
        }
        return tasks
    }()

    static func loadTasks() -> [Task] {
        return tasks
    }
}
