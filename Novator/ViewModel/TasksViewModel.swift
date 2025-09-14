import Foundation
import SwiftUI

// MARK: - TasksViewModel
class TasksViewModel: ObservableObject {
    @Published var program: LearningProgram?
    @Published var selectedAnswer: String?
    @Published var showResult: Bool = false
    @Published var isCorrect: Bool = false
    let profile: UserProfileViewModel
    
    init(profile: UserProfileViewModel, lessonId: String) {
        self.profile = profile
        profile.saveProfile()
        self.program = TaskManager.createLearningProgram(for: lessonId, completedTasks: profile.profile.completedTasks)
        print("TasksViewModel: Initialized with lesson (lessonId), tasks count: \(program?.tasks.count ?? 0)")
    }
    
    // MARK: - Current Task
    var currentTask: AppTask? {
        program?.currentTask
    }
    
    var currentTaskNumber: Int {
        guard let program = program else { return 0 }
        return program.currentIndex
    }
    
    var totalTasks: Int {
        program?.tasks.count ?? 0
    }
    
    var progress: Double {
        guard let program = program, !program.tasks.isEmpty else { return 0 }
        return Double(program.currentIndex) / Double(program.tasks.count)
    }
    
    var progressText: String {
        "\(currentTaskNumber)/\(totalTasks)"
    }
    
    // MARK: - Result and Action
    var resultColor: Color {
        isCorrect ? Color("redCorrect") : Color("taskMistake")
    }
    
    var resultText: String {
        isCorrect ? "Правильно" : "Ошибка"
    }
    
    var isNextButtonActive: Bool {
        showResult
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
    
    // MARK: - Logic
    func checkAnswer() {
        guard let task = currentTask, let answer = selectedAnswer else { return }
        isCorrect = answer == task.correctAnswer
        showResult = true
        if isCorrect {
            profile.addStars(task.stars)
            profile.addRaitingPoints(task.raitingPoints)
            profile.completeTask(task.id)
            AchievementManager.checkAchievements(for: profile)
            if let lessonId = program?.lessonId, isLessonCompleted(lessonId: lessonId) {
                profile.completeLesson(lessonId)
            }
        }
    }
    
    func loadNextTask() {
        guard var mutableProgram = program else { return }
        if !isCorrect {
            let oldIndex = mutableProgram.currentIndex
            let taskToMove = mutableProgram.tasks.remove(at: oldIndex)
            mutableProgram.tasks.append(taskToMove)
            mutableProgram.currentIndex = oldIndex
        } else {
            mutableProgram.currentIndex += 1
        }
        program = mutableProgram
        selectedAnswer = nil
        showResult = false
        isCorrect = false
        print("🔔 TasksViewModel: loadNextTask called, new currentTask = \(String(describing: currentTask?.id))")
    }
    
    private func isLessonCompleted(lessonId: String) -> Bool {
        guard let lesson = TaskManager.getLesson(for: lessonId) else { return false }
        let lessonTaskIds = Set(lesson.tasks.map { $0.id })
        let completedIds = Set(profile.profile.completedTasks)
        return lessonTaskIds.isSubset(of: completedIds)
    }
    
    // MARK: - Analytics / Logging
    func logAppear() {
        print("TaskDetailView: Appeared, current task: \(currentTask?.question ?? "none")")
    }
}
