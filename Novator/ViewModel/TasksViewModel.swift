import Foundation
import SwiftUI

class TasksViewModel: ObservableObject {
    @Published var program: LearningProgram?
    @Published var selectedAnswer: String?
    @Published var showResult: Bool = false
    @Published var isCorrect: Bool = false
    let profile: UserProfileViewModel
    
    init(profile: UserProfileViewModel) {
        self.profile = profile
        // Сброс completedTasks для теста (удалите после отладки)
        profile.profile.completedTasks = []
        profile.saveProfile()
        self.program = TaskManager.createLearningProgram(for: profile.profile.level, completedTasks: profile.profile.completedTasks)
        print("TasksViewModel: Initialized with level \(profile.profile.level), tasks count: \(program?.tasks.count ?? 0)")
    }
    
    var currentTask: Task? {
        program?.currentTask
    }
    
    func checkAnswer() {
        guard let task = currentTask, let answer = selectedAnswer else {
            print("TasksViewModel: No task or answer selected")
            return
        }
        isCorrect = answer == task.correctAnswer
        showResult = true
        if isCorrect {
            profile.addPoints(task.points)
            profile.completeTask(task.id)
            AchievementManager.checkAchievements(for: profile)
            print("TasksViewModel: Correct answer, points: \(task.points), total: \(profile.profile.points), streak: \(profile.profile.streak)")
        } else {
            print("TasksViewModel: Incorrect answer for task: \(task.question)")
        }
    }
    
    func loadNextTask() {
        program?.nextTask()
        selectedAnswer = nil
        showResult = false
        print("TasksViewModel: Next task loaded, index: \(program?.currentIndex ?? -1), tasks left: \((program?.tasks.count ?? 0) - (program?.currentIndex ?? 0))")
    }
    
    private func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        if let lastActivity = UserDefaults.standard.object(forKey: "lastActivityDate") as? Date,
           Calendar.current.isDate(lastActivity, inSameDayAs: today) {
            print("TasksViewModel: Streak already updated today")
            return
        }
        profile.profile.streak += 1
        UserDefaults.standard.set(today, forKey: "lastActivityDate")
        profile.saveProfile()
        print("TasksViewModel: Streak updated to \(profile.profile.streak)")
    }
}
