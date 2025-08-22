import SwiftUI
import Foundation

struct TasksView: View {
    @StateObject private var viewModel: TasksViewModel
    @Binding var navigationPath: NavigationPath
    
    init(profile: UserProfileViewModel, navigationPath: Binding<NavigationPath>) {
        self._viewModel = StateObject(wrappedValue: TasksViewModel(profile: profile))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Ваш уровень: \(viewModel.profile.profile.level.capitalized)")
                .font(.system(.title2, design: .rounded))
                .foregroundColor(Color("AppRed"))
            
            HStack(spacing: 20) {
                statView(icon: "flame.fill", value: "\(viewModel.profile.profile.streak)")
            }
            .padding()
            
            Text("Программа обучения: Математика и логика")
                .font(.system(.subheadline, design: .rounded))
                .foregroundColor(.gray)
            
            if let task = viewModel.currentTask {
                NavigationLink(destination: TaskDetailView(viewModel: viewModel)) {
                    Text("Решать задачи (\(task.level.capitalized))")
                        .font(.system(.title2, design: .rounded))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("AppRed"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            } else {
                Text("Нет доступных задач для уровня \(viewModel.profile.profile.level.capitalized)")
                    .font(.system(.title2, design: .rounded))
                    .foregroundColor(Color("AppRed"))
                Text("Пройдите тест уровня или сбросьте прогресс")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.gray)
                Button(action: {
                    viewModel.profile.profile.completedTasks = []
                    viewModel.profile.saveProfile()
                    viewModel.program = TaskManager.createLearningProgram(for: viewModel.profile.profile.level, completedTasks: [])
                    print("TasksView: Progress reset, tasks reloaded for level \(viewModel.profile.profile.level)")
                }) {
                    Text("Сбросить прогресс")
                        .font(.system(.subheadline, design: .rounded))
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
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
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(viewModel.profile.theme.colorScheme)
        .onAppear {
            print("TasksView: Appeared, level: \(viewModel.profile.profile.level), current task: \(viewModel.currentTask?.question ?? "none")")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                statView(icon: "star.fill", value: "\(viewModel.profile.profile.points)")
            }
        }
    }
    
    @ViewBuilder
    private func statView(icon: String, value: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Color("AppRed"))
                .frame(width: 20, alignment: .leading)
            Text(value)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}

struct TaskDetailView: View {
    @ObservedObject var viewModel: TasksViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            if let task = viewModel.currentTask {
                Text(task.isLogicalTrick ? "Логическая задача" : "Математическая задача")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.gray)
                
                Text(task.question)
                    .font(.system(.title2, design: .rounded))
                    .foregroundColor(Color("AppRed"))
                    .padding()
                
                ForEach(task.options ?? [], id: \.self) { option in
                    Button(action: {
                        viewModel.selectedAnswer = option
                        viewModel.checkAnswer()
                    }) {
                        Text(option)
                            .font(.system(.body, design: .rounded))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.selectedAnswer == option ? Color("AppRed") : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                Spacer()
            } else {
                Text("Задача недоступна")
                    .font(.system(.title2, design: .rounded))
                    .foregroundColor(Color("AppRed"))
            }
        }
        .padding()
        .navigationTitle("Задача")
        .navigationBarTitleDisplayMode(.inline)
        .alert(isPresented: $viewModel.showResult) {
            Alert(
                title: Text(viewModel.isCorrect ? "Правильно!" : "Неправильно"),
                message: Text(viewModel.isCorrect ? "Отличная работа! +\((viewModel.currentTask?.points ?? 0)) очков" : viewModel.currentTask?.explanation ?? "Попробуйте снова"),
                dismissButton: .default(Text("Далее")) {
                    viewModel.loadNextTask()
                }
            )
        }
        .preferredColorScheme(viewModel.profile.theme.colorScheme)
        .onAppear {
            print("TaskDetailView: Appeared, current task: \(viewModel.currentTask?.question ?? "none")")
        }
    }
}

struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(profile: UserProfileViewModel(), navigationPath: .constant(NavigationPath()))
    }
}
