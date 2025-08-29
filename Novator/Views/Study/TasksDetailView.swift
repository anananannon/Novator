import SwiftUI
import Foundation

// MARK: - TaskDetailView
struct TaskDetailView: View {
    @StateObject private var viewModel: TasksViewModel
    @Environment(\.dismiss) private var dismiss

    // MARK: - Initialization
    init(profile: UserProfileViewModel) {
        self._viewModel = StateObject(wrappedValue: TasksViewModel(profile: profile))
    }
    
    // MARK: Body
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(.subheadline))
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .padding(6)
                        .background(.thinMaterial, in: Capsule())
                }
                
                ProgressBarView(progress: viewModel.progress)
                    .frame(maxWidth: .infinity)
            }
            
            
            
            Spacer()
            
            if let task = viewModel.currentTask {
//                taskHeader(task: task)
                taskQuestion(task: task)
                Spacer()
                taskOptions(task: task)
                
                Button(action: { // вот эта кнопка
                    viewModel.checkAnswer()
                }, label: {
                    PrimaryButton(title: viewModel.isCorrect ? "Далее" : "Проверить")
                })
            } else {
                noTaskView
            }
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
//        .alert(isPresented: $viewModel.showResult) { taskAlert } // что бы убрать алерт и сделать кнопку continue //показывает результат в showResult in TasksViewModel
        .preferredColorScheme(viewModel.profile.theme.colorScheme)
        .onAppear { logAppear() }
        .background(Color("TaskBackground").ignoresSafeArea())
    }
}

// MARK: - TaskDetailView Subviews
private extension TaskDetailView {

    // MARK: - ProgressBarView
    struct ProgressBarView: View {
        let progress: Double
        var color: Color = Color("AppRed")
        
        var body: some View {
            ProgressView(value: progress)
                .tint(color)
                .animation(.easeIn(duration: 0.3), value: progress)
        }
    }
    
    func taskHeader(task: Task) -> some View {
        Text(task.isLogicalTrick ? "Логическая задача" : "Математическая задача")
            .font(.system(.subheadline))
            .foregroundColor(.gray)
    }

    func taskQuestion(task: Task) -> some View {
        Text(task.question)
            .font(.system(.title2))
            .foregroundColor(Color("AppRed"))
            .padding(.all, 50)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.white)))
    }

    @ViewBuilder
    func taskOptions(task: Task) -> some View {
        ForEach(task.options ?? [], id: \.self) { option in
            Button(action: {
                viewModel.selectedAnswer = option
//                viewModel.checkAnswer() // это вызывает alerts, а так же проверяет, правильный ли вопрос
            }) {
                Text(option)
                    .font(.system(.body))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.selectedAnswer == option ? Color("AppRed") : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }

    var noTaskView: some View {
        VStack(spacing: 16) {
            Text("Вы успешно прошли уровень")
                .font(.system(.title2))
                .foregroundColor(Color("AppRed"))

            Button(action: { /*navigationPath = NavigationPath()*/ dismiss() }) {
                Text("Вернуться в меню")
                    .font(.system(.title2))
                    .padding()
                    .background(Color("AppRed"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            Spacer()
        }
    }

    var taskAlert: Alert {
        Alert(
            title: Text(viewModel.isCorrect ? "Правильно!" : "Неправильно"),
            message: Text(viewModel.isCorrect ? "Отличная работа! +\((viewModel.currentTask?.points ?? 0)) очков" : viewModel.currentTask?.explanation ?? "Попробуйте снова"),
            dismissButton: .default(Text("Далее")) {
                viewModel.loadNextTask()
            }
        )
    }

    func logAppear() {
        print("TaskDetailView: Appeared, current task: \(viewModel.currentTask?.question ?? "none")")
    }
}

// MARK: - Extension для прогресса
extension TasksViewModel {
    var progress: Double {
        guard let program = program, !program.tasks.isEmpty else { return 0 }
        return Double(program.currentIndex) / Double(program.tasks.count)
    }
}
