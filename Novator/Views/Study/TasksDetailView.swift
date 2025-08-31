import SwiftUI
import Foundation

// MARK: - TaskDetailView
struct TaskDetailView: View {
    @StateObject private var viewModel: TasksViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var showContent = false
    
    init(profile: UserProfileViewModel) {
        self._viewModel = StateObject(wrappedValue: TasksViewModel(profile: profile))
    }
    
    var body: some View {
        ZStack {
            backgroundView
            contentView
                .padding()
                .offset(x: showContent ? 0 : UIScreen.main.bounds.width) // старт за экраном справа !!!Этот комментарий не убирать
                .opacity(showContent ? 1 : 0) // добавляем плавное появление !!!Этот комментарий не убирать
                .animation(.easeInOut(duration: 0.4).delay(0.2), value: showContent) // анимация въезда !!!Этот комментарий не убирать
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { showContent = true } // запускаем анимацию после небольшой задержки !!!Этот комментарий не убирать
            logAppear()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(viewModel.profile.theme.colorScheme)
    }
}

// MARK: - Views
private extension TaskDetailView {
    
    var backgroundView: some View {
        Group {
            if viewModel.profile.theme.colorScheme == .light {
                Color.white.ignoresSafeArea() // 1. Белый фон сразу !!!Этот комментарий не убирать
            } else {
                Color.black.ignoresSafeArea()
            }
        }
    }
    
    var contentView: some View {
        VStack(spacing: 20) {
            headerView
            Spacer()
            if let task = viewModel.currentTask {
                taskContentView(task: task)
                    .id(task.id)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing), // новый появляется справа + плавно !!!Этот комментарий не убирать
                        removal: .move(edge: .leading)     // старый уходит влево + плавно растворяется !!!Этот комментарий не убирать
                    ))
                    .animation(.easeInOut(duration: 0.3), value: viewModel.currentTask?.id)
                    .preferredColorScheme(viewModel.profile.theme.colorScheme)
            } else {
                noTaskView
            }
        }
    }
    
    var headerView: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "xmark")
                    .font(.system(.title))
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding(6)
            }
            VStack(alignment: .leading) {
                ProgressBarView(progress: viewModel.progress)
                    .frame(maxWidth: .infinity)
                Text("\(viewModel.currentTaskNumber)/\(viewModel.totalTasks)")
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .padding(.top, 3)
            }
        }
    }
    
    func taskContentView(task: Task) -> some View {
        VStack {
            taskQuestion(task: task)
                .padding(.bottom, 30)
            taskOptions(task: task)
            resultAndActionView
        }
    }
    
    var resultAndActionView: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 16)
                .fill(viewModel.isCorrect ? Color("redCorrect") : Color("taskMistake"))
                .frame(minWidth: 340, maxHeight: 160)
                .overlay(resultOverlay)
                .opacity(viewModel.showResult ? 1 : 0)
                .scaleEffect(y: viewModel.showResult ? 1 : 0, anchor: .bottom)
                .animation(.easeOut(duration: 0.3), value: viewModel.showResult)
                .padding(.top)
            
            Button(action: viewModel.actionButtonTapped) {
                Text(viewModel.actionButtonTitle)
                    .font(.system(.title3))
                    .frame(maxWidth: 333.63, maxHeight: 47)
                    .animation(nil, value: viewModel.actionButtonTitle)
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.bottom, 4)
        }
    }
    
    var resultOverlay: some View {
        VStack(alignment: .leading) {
            Text(viewModel.isCorrect ? "\(Image(systemName: "checkmark.circle.fill")) Правильно" : "\(Image(systemName: "xmark.circle.fill")) Ошибка")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(viewModel.isCorrect ? Color(.white) : Color("taskText"))
                .padding(.leading, 15)
                .padding(.top, 20)
            
            if !viewModel.isCorrect {
                Text(viewModel.currentTask?.explanation ?? "")
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundStyle(Color("taskExplanation"))
                    .padding(.horizontal)
                    .padding(.top, 3)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var noTaskView: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("Урок пройден!")
                .font(.system(.title2))
                .foregroundColor(Color("AppRed"))
            Spacer()
            Button { dismiss() } label: {
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
    
    func logAppear() {
        print("TaskDetailView: Appeared, current task: \(viewModel.currentTask?.question ?? "none")")
    }
}

// MARK: - Subviews
private extension TaskDetailView {
    struct ProgressBarView: View {
        let progress: Double
        var color: Color = Color("AppRed")
        var body: some View {
            ProgressView(value: progress)
                .tint(color)
                .animation(.easeIn(duration: 0.3), value: progress)
        }
    }
    
    func taskQuestion(task: Task) -> some View {
        Text(task.question)
            .font(.system(.title3, design: .monospaced))
            .fontWeight(.semibold)
            .frame(minWidth: 340, minHeight: 98)
            .background(Color("TaskBackground"))
            .foregroundColor(.primary)
            .cornerRadius(16)
    }
    
    @ViewBuilder
    func taskOptions(task: Task) -> some View {
        let options = task.options ?? []
        let columns = [GridItem(.flexible()), GridItem(.flexible())] // 2 колонки !!!Этот комментарий не убирать
        
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(options, id: \.self) { option in
                Button {
                    guard !viewModel.showResult else { return } // блокировка после проверки !!!Этот комментарий не убирать
                    viewModel.selectedAnswer = option
                } label: {
                    Text(option)
                        .font(.system(.body, design: .monospaced))
                        .fontWeight(.medium)
                        .padding()
                        .frame(minWidth: 158, minHeight: 81)
                        .background(viewModel.selectedAnswer == option ? Color("AppRed") : Color("TaskBackground"))
                        .foregroundColor(viewModel.selectedAnswer == option ? Color(.white) : .primary)
                        .animation(nil, value: viewModel.selectedAnswer)
                        .cornerRadius(16)
                }
                .disabled(viewModel.showResult) // визуально блокируем
            }
        }
    }
}

// MARK: - ViewModel Extension
extension TasksViewModel {
    var progress: Double {
        guard let program = program, !program.tasks.isEmpty else { return 0 }
        return Double(program.currentIndex) / Double(program.tasks.count)
    }
}
