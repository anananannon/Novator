import SwiftUI
import Foundation

// MARK: - LevelTestView
struct LevelTestView: View {
    // MARK: - Properties
    @ObservedObject var profile: UserProfileViewModel
    @Binding var navigationPath: NavigationPath
    
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String?
    @State private var showResult = false
    @State private var correctAnswers = 0
    
    // MARK: - Test Data
    private let testTasks: [Task] = [
        Task(id: UUID(), category: "math", level: "beginner", question: "2 + 3 = ?", options: ["5", "6", "4", "7"], correctAnswer: "5", explanation: "Сложите 2 и 3, чтобы получить 5.", points: 10, isLogicalTrick: false),
        Task(id: UUID(), category: "math", level: "intermediate", question: "Решите: x + 4 = 10", options: ["6", "5", "7", "8"], correctAnswer: "6", explanation: "Вычтите 4 из 10: x = 10 - 4 = 6.", points: 20, isLogicalTrick: false),
        Task(id: UUID(), category: "logic", level: "advanced", question: "Если все кошки мурлыкают, а Тигр - кошка, то что делает Тигр?", options: ["Мурлыкает", "Лает", "Крякает", "Рычит"], correctAnswer: "Мурлыкает", explanation: "По условию, все кошки мурлыкают, значит, Тигр мурлыкает.", points: 50, isLogicalTrick: true)
    ]
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            if isTestCompleted {
                completionView
            } else {
                questionView
            }
        }
        .padding()
        .navigationTitle("Тест уровня")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showResult, content: resultAlert)
        .onAppear(perform: resetTest)
        .preferredColorScheme(profile.theme.colorScheme)
    }
}

// MARK: - Computed Properties
private extension LevelTestView {
    var isTestCompleted: Bool {
        currentQuestionIndex >= testTasks.count
    }
    
    var currentTask: Task {
        testTasks[currentQuestionIndex]
    }
}

// MARK: - Views
private extension LevelTestView {
    
    var questionView: some View {
        VStack(spacing: 20) {
            Text(currentTask.question)
                .font(.system(.title2, design: .rounded))
                .foregroundColor(Color("AppRed"))
                .padding()
            
            ForEach(currentTask.options ?? [], id: \.self) { option in
                Button(action: {
                    selectedAnswer = option
                    checkAnswer()
                }) {
                    Text(option)
                        .font(.system(.body, design: .rounded))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(selectedAnswer == option ? Color("AppRed") : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    var completionView: some View {
        VStack(spacing: 20) {
            Text("Тест завершен! Ваш уровень: \(profile.profile.level.capitalized)")
                .font(.system(.title2))
                .foregroundColor(Color("AppRed"))
                .padding()
            
            Button(action: { navigationPath = NavigationPath() }) {
                Text("Вернуться в меню")
                    .font(.system(.title2))
                    .padding()
                    .background(Color("AppRed"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}

// MARK: - Alert
private extension LevelTestView {
    func resultAlert() -> Alert {
        Alert(
            title: Text("Результат"),
            message: Text(selectedAnswer == currentTask.correctAnswer
                          ? "Правильно!"
                          : "Неправильно. \(currentTask.explanation)"),
            dismissButton: .default(Text("Далее"), action: nextQuestion)
        )
    }
}

// MARK: - Actions
private extension LevelTestView {
    func checkAnswer() {
        guard let answer = selectedAnswer else { return }
        showResult = true
        if answer == currentTask.correctAnswer {
            correctAnswers += 1
            profile.addPoints(currentTask.points)
            AchievementManager.checkAchievements(for: profile)
            print("LevelTestView: Correct answer, points: \(profile.profile.points), correct count: \(correctAnswers)")
        }
    }
    
    func nextQuestion() {
        currentQuestionIndex += 1
        selectedAnswer = nil
        
        if isTestCompleted {
            let newLevel: String
            switch correctAnswers {
            case 2...:
                newLevel = "advanced"
            case 1:
                newLevel = "intermediate"
            default:
                newLevel = "beginner"
            }
            profile.updateLevel(newLevel)
            profile.profile.completedTasks = []
            profile.saveProfile()
            print("LevelTestView: Level updated to \(newLevel), completed tasks reset")
        }
    }
    
    func resetTest() {
        currentQuestionIndex = 0
        correctAnswers = 0
        selectedAnswer = nil
        showResult = false
        print("LevelTestView: Test reset, current level: \(profile.profile.level)")
    }
}

// MARK: - Preview
struct LevelTestView_Previews: PreviewProvider {
    static var previews: some View {
        LevelTestView(profile: UserProfileViewModel(), navigationPath: .constant(NavigationPath()))
    }
}
