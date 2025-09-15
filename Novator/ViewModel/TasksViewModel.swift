import Foundation
import SwiftUI

// MARK: - TasksViewModel
class TasksViewModel: ObservableObject {
    @Published var program: LearningProgram?
    @Published var selectedAnswer: String?
    @Published var showResult: Bool = false
    @Published var isCorrect: Bool = false
    @Published var mistakeCount: Int = 0
    let profile: UserProfileViewModel

    // Новые свойства для отложенного начисления
    private var completedTaskIds: [UUID] = []
    private var accumulatedStars = 0
    private var accumulatedRaitingPoints = 0

    init(profile: UserProfileViewModel, lessonId: String) {
        self.profile = profile
        self.program = TaskManager.createLearningProgram(
            for: lessonId,
            completedTasks: profile.profile.completedTasks
        )
        print("TasksViewModel: Initialized with lesson \(lessonId), tasks count: \(program?.tasks.count ?? 0)")
    }

    // MARK: - Текущая задача
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

    // MARK: - Result & Action
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

    // MARK: - Проверка ответа
    func checkAnswer() {
        guard let task = currentTask, let answer = selectedAnswer else { return }
        isCorrect = answer == task.correctAnswer
        showResult = true

        if isCorrect {
            // Сохраняем прогресс локально
            completedTaskIds.append(task.id)
            accumulatedStars += task.stars
            accumulatedRaitingPoints += task.raitingPoints
        } else {
            mistakeCount += 1
            print("🔔 TasksViewModel: Ошибка зафиксирована, текущий mistakeCount = \(mistakeCount)")
        }
    }

    // MARK: - Переход к следующей задаче
    func loadNextTask() {
        guard var mutableProgram = program else { return }
        if !isCorrect {
            // Неправильный ответ — ставим задачу в конец
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
        print("🔔 TasksViewModel: loadNextTask, currentTask = \(String(describing: currentTask?.id))")
    }

    // MARK: - Завершение урока и начисление очков
    func completeLessonIfFinished() {
        guard let lessonId = program?.lessonId else { return }

        let totalTasksInLesson = TaskManager.getLesson(for: lessonId)?.tasks.count ?? 0
        if completedTaskIds.count == totalTasksInLesson {
            // Начисляем очки и помечаем задачи как выполненные
            profile.addStars(accumulatedStars)
            profile.addRaitingPoints(accumulatedRaitingPoints)
            completedTaskIds.forEach { profile.completeTask($0) }
            profile.completeLesson(lessonId)

            // Проверяем достижения
            AchievementManager.checkAchievements(for: profile)

            // Сброс локальных накопителей
            accumulatedStars = 0
            accumulatedRaitingPoints = 0
            completedTaskIds = []
            mistakeCount = 0

            print("✅ Lesson \(lessonId) полностью завершён. Начислены все очки и проверены достижения.")
        }
    }

    // MARK: - Проверка завершения урока для внутренних нужд
    private func isLessonCompleted(lessonId: String) -> Bool {
        guard let lesson = TaskManager.getLesson(for: lessonId) else { return false }
        let lessonTaskIds = Set(lesson.tasks.map { $0.id })
        let completedIds = Set(profile.profile.completedTasks)
        return lessonTaskIds.isSubset(of: completedIds)
    }

    // MARK: - Аналитика
    func logAppear() {
        print("TaskDetailView: Appeared, current task: \(currentTask?.question ?? "none")")
    }
}
