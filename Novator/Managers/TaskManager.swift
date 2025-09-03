import Foundation
struct Lesson: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let tasks: [AppTask]
    
    var lessonStars: Int {
       tasks.reduce(0) { $0 + $1.stars }
   }
    var lessonRaitingPoints: Int {
        tasks.reduce(0) { $0 + $1.raitingPoints }
    }
}
struct LearningProgram {
    let tasks: [AppTask]
    let lessonId: String
    var currentIndex: Int
    init(tasks: [AppTask], lessonId: String) {
        self.tasks = tasks.sorted { $0.stars < $1.stars }
        self.lessonId = lessonId
        self.currentIndex = 0
        print("LearningProgram: Lesson \(lessonId), \(tasks.count) tasks available")
    }
    var currentTask: AppTask? {
        currentIndex < tasks.count ? tasks[currentIndex] : nil
    }
    mutating func nextTask() -> AppTask? {
        currentIndex += 1
        return currentTask
    }
}
class TaskManager {
    static let lessons: [Lesson] = {
        guard let url = Bundle.main.url(forResource: "tasks", withExtension: "json") else {
            print("Error: tasks.json not found in Bundle")
            return []
        }
        guard let data = try? Data(contentsOf: url) else {
            print("Error: Failed to read tasks.json")
            return []
        }
        struct LessonsWrapper: Codable {
            let lessons: [Lesson]
        }
        guard let wrapper = try? JSONDecoder().decode(LessonsWrapper.self, from: data) else {
            print("Error: Failed to decode tasks.json")
            return []
        }
        print("TaskManager: Loaded (wrapper.lessons.count) lessons from tasks.json")
        return wrapper.lessons
    }()
    static func createLearningProgram(for lessonId: String, completedTasks: [UUID]) -> LearningProgram {
        guard let lesson = lessons.first(where: { $0.id == lessonId }) else {
            print("TaskManager: No lesson found for id (lessonId)")
            return LearningProgram(tasks: [], lessonId: lessonId)
        }
        let filteredTasks = lesson.tasks.filter { !completedTasks.contains($0.id) }
        print("TaskManager: Creating LearningProgram for lesson: (lessonId), Available tasks: (filteredTasks.count)")
        if filteredTasks.isEmpty {
            print("TaskManager: No tasks for lesson (lessonId)")
        }
        return LearningProgram(tasks: filteredTasks, lessonId: lessonId)
    }
    static func getLesson(for lessonId: String) -> Lesson? {
        lessons.first { $0.id == lessonId }
    }
}
