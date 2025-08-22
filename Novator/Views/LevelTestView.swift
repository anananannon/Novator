import SwiftUI
import Foundation

struct LevelTestView: View {
    @ObservedObject var profile: UserProfileViewModel
    @Binding var navigationPath: NavigationPath
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswer: String?
    @State private var showResult = false
    @State private var correctAnswers = 0
    
    let testTasks = [
        Task(id: UUID(), category: "math", level: "beginner", question: "2 + 3 = ?", options: ["5", "6", "4", "7"], correctAnswer: "5", explanation: "Сложите 2 и 3, чтобы получить 5.", points: 10, isLogicalTrick: false),
        Task(id: UUID(), category: "math", level: "intermediate", question: "Решите: x + 4 = 10", options: ["6", "5", "7", "8"], correctAnswer: "6", explanation: "Вычтите 4 из 10: x = 10 - 4 = 6.", points: 20, isLogicalTrick: false),
        Task(id: UUID(), category: "logic", level: "advanced", question: "Если все кошки мурлыкают, а Тигр - кошка, то что делает Тигр?", options: ["Мурлыкает", "Лает", "Крякает", "Рычит"], correctAnswer: "Мурлыкает", explanation: "По условию, все кошки мурлыкают, значит, Тигр мурлыкает.", points: 50, isLogicalTrick: true)
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            if currentQuestionIndex < testTasks.count {
                Text(testTasks[currentQuestionIndex].question)
                    .font(.system(.title2, design: .rounded))
                    .foregroundColor(Color("AppRed"))
                    .padding()
                
                ForEach(testTasks[currentQuestionIndex].options ?? [], id: \.self) { option in
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
            } else {
                Text("Тест завершен! Ваш уровень: \(profile.profile.level.capitalized)")
                    .font(.system(.title2, design: .rounded))
                    .foregroundColor(Color("AppRed"))
                    .padding()
                Button(action: {
                    navigationPath = NavigationPath()
                }) {
                    Text("Вернуться в меню")
                        .font(.system(.title2, design: .rounded))
                        .padding()
                        .background(Color("AppRed"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
        }
        .padding()
        .navigationTitle("Тест уровня")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showResult) {
            Alert(
                title: Text("Результат"),
                message: Text(selectedAnswer == testTasks[currentQuestionIndex].correctAnswer ? "Правильно!" : "Неправильно. \(testTasks[currentQuestionIndex].explanation)"),
                dismissButton: .default(Text("Далее")) {
                    currentQuestionIndex += 1
                    selectedAnswer = nil
                    if currentQuestionIndex >= testTasks.count {
                        let newLevel = correctAnswers >= 2 ? "advanced" : correctAnswers == 1 ? "intermediate" : "beginner"
                        profile.updateLevel(newLevel)
                        profile.profile.completedTasks = [] // Сброс задач для нового уровня
                        profile.saveProfile()
                        print("LevelTestView: Level updated to \(newLevel), completed tasks reset")
                    }
                }
            )
        }
        .onAppear {
            currentQuestionIndex = 0
            correctAnswers = 0
            selectedAnswer = nil
            showResult = false
            print("LevelTestView: Test reset, current level: \(profile.profile.level)")
        }
        .preferredColorScheme(profile.theme.colorScheme)
    }
    
    private func checkAnswer() {
        if let answer = selectedAnswer {
            showResult = true
            if answer == testTasks[currentQuestionIndex].correctAnswer {
                correctAnswers += 1
                profile.addPoints(testTasks[currentQuestionIndex].points)
                AchievementManager.checkAchievements(for: profile)
                print("LevelTestView: Correct answer, points: \(profile.profile.points), correct count: \(correctAnswers)")
            }
        }
    }
}

struct LevelTestView_Previews: PreviewProvider {
    static var previews: some View {
        LevelTestView(profile: UserProfileViewModel(), navigationPath: .constant(NavigationPath()))
    }
}
