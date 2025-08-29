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
        profile.profile.completedTasks = [] // Сброс для теста
        profile.saveProfile()
        self.program = TaskManager.createLearningProgram(for: profile.profile.level, completedTasks: profile.profile.completedTasks)
        print("TasksViewModel: Initialized with level \(profile.profile.level), tasks count: \(program?.tasks.count ?? 0)")
    }
    
    var currentTask: Task? {
        program?.currentTask
    }
    
    func checkAnswer() {
        guard let task = currentTask, let answer = selectedAnswer else { return }
        isCorrect = answer == task.correctAnswer
        showResult = true // показывать результат в alerts
        if isCorrect {
            profile.addPoints(task.points)
            profile.completeTask(task.id)
            AchievementManager.checkAchievements(for: profile)
        }
    }
    
    func loadNextTask() {
        program?.nextTask()
        selectedAnswer = nil
        showResult = false
    }
}

extension TasksViewModel {
    var isNextButtonActive: Bool {
        showResult && isCorrect
    }

    var actionButtonTitle: String {
        isNextButtonActive ? "Далее" : "Проверить"
    }

    func actionButtonTapped() {
        if isNextButtonActive {
            loadNextTask()
        } else {
            checkAnswer()
        }
    }
}
