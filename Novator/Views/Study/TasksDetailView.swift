import SwiftUI
import Foundation

// MARK: - TaskDetailView
struct TaskDetailView: View {
    @StateObject private var viewModel: TasksViewModel
    @Environment(\.dismiss) private var dismiss
    
    // Флаг для анимации появления контента
    @State private var showContent = false
    
    // MARK: - Initialization
    init(profile: UserProfileViewModel) {
        self._viewModel = StateObject(wrappedValue: TasksViewModel(profile: profile))
    }
    
    // MARK: Body
    var body: some View {
        ZStack {
            // 1. Белый фон сразу
            Color.white.ignoresSafeArea()
            
            // 2. Основное содержимое — появляется с анимацией справа налево
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
                    taskQuestion(task: task)
                        .padding(.bottom, 30)
                    taskOptions(task: task)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.actionButtonTapped()
                    }) {
                        PrimaryButton(title: viewModel.actionButtonTitle)
                    }
                    
                } else {
                    noTaskView
                }
            }
            .padding()
//            .background(Color("TaskBackground").ignoresSafeArea())
            .offset(x: showContent ? 0 : UIScreen.main.bounds.width) // старт за экраном справа
            .opacity(showContent ? 1 : 0) // добавляем плавное появление
            .animation(.easeInOut(duration: 0.4).delay(0.2), value: showContent) // анимация въезда
        }
        .onAppear {
            // запускаем анимацию после небольшой задержки
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { //тут число
                showContent = true
            }
            logAppear()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(viewModel.profile.theme.colorScheme)
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
            .fontWeight(.semibold)
            .frame(minWidth: 343, minHeight: 98)
            .background(Color("TaskBackground"))
            .foregroundColor(.primary)
            .cornerRadius(16)
    }

    @ViewBuilder
    func taskOptions(task: Task) -> some View {
        let options = task.options ?? []
        let columns = [GridItem(.flexible()), GridItem(.flexible())] // 2 колонки
        
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(options, id: \.self) { option in
                Button {
                    // Блокируем выбор после проверки правильного ответа
                    guard !viewModel.showResult else { return }
                    viewModel.selectedAnswer = option
                } label: {
                    Text(option)
                        .font(.body)
                        .padding()
                        .frame(minWidth: 158, minHeight: 81)
                        .background(viewModel.selectedAnswer == option ? Color("AppRed") : Color("TaskBackground"))
                        .foregroundColor(.primary)
                        .cornerRadius(16)
                }
                .disabled(viewModel.showResult) // дополнительно блокируем визуально
            }
        }
    }


    var noTaskView: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("Урок пройден!")
                .font(.system(.title2))
                .foregroundColor(Color("AppRed"))

            Spacer()
            Button(action: { dismiss() }) {
                HStack {
                    Image(systemName: "shippingbox.fill")
                       
                    Text("Получить награды")
                        
                }
                .font(.system(.title2))
                .padding()
                .background(Color("AppRed"))
                .foregroundColor(.white)
                .cornerRadius(15)

            }
        }
    }
    
    
    // Alert и след вопрос
    var taskAlert: Alert {
        Alert(
            title: Text(viewModel.isCorrect ? "Правильно!" : "Неправильно"),
            message: Text(viewModel.isCorrect ? "Отличная работа! +\((viewModel.currentTask?.points ?? 0)) очков" : viewModel.currentTask?.explanation ?? "Попробуйте снова"),
            dismissButton: .default(Text("Далее")) {
                viewModel.loadNextTask() // переход к след вопросу
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
