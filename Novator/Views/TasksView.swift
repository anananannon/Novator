import SwiftUI
import Foundation

struct TasksView: View {
    @ObservedObject var profile: UserProfileViewModel
    @Binding var navigationPath: NavigationPath
    @State private var currentTask: Task?
    @State private var selectedAnswer: String?
    @State private var showResult = false
    private let tasks = TaskManager.loadTasks()

    var body: some View {
        VStack(spacing: 20) {
            if let task = currentTask {
                Text(task.question)
                    .font(.system(.title2, design: .rounded))
                    .foregroundColor(Color("AppRed"))
                    .padding()

                ForEach(task.options ?? [], id: \.self) { option in
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
                Text("Нет доступных задач для вашего уровня (\(profile.profile.level))")
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

            Spacer()
        }
        .padding()
        .navigationTitle("Решение задач")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $showResult) {
            Alert(
                title: Text(selectedAnswer == currentTask?.correctAnswer ? "Правильно!" : "Неправильно")
                    .font(.system(.headline, design: .rounded)),
                message: Text(selectedAnswer == currentTask?.correctAnswer ? "Отличная работа! +10 очков" : currentTask?.explanation ?? "")
                    .font(.system(.body, design: .rounded)),
                dismissButton: .default(Text("Далее").font(.system(.body, design: .rounded))) {
                    profile.completeTask(currentTask?.id ?? UUID())
                    loadNextTask()
                }
            )
        }
        .onAppear {
            loadNextTask()
        }
    }

    private func loadNextTask() {
        let availableTasks = tasks.filter { $0.level == profile.profile.level && !profile.profile.completedTasks.contains($0.id) }
        currentTask = availableTasks.randomElement()
        selectedAnswer = nil
        if availableTasks.isEmpty {
            navigationPath = NavigationPath()
        }
    }

    private func checkAnswer() {
        guard let task = currentTask, let answer = selectedAnswer else { return }
        if answer == task.correctAnswer {
            profile.addPoints(10)
            AchievementManager.checkAchievements(for: profile)
        }
        showResult = true
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(profile: UserProfileViewModel(), navigationPath: .constant(NavigationPath()))
    }
}
