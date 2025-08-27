import SwiftUI
import Foundation

// MARK: - TasksView
struct TasksView: View {
    @StateObject private var viewModel: TasksViewModel
    @Binding var navigationPath: NavigationPath
    @Binding var selectedTab: Int

    // MARK: - Initialization
    init(profile: UserProfileViewModel, navigationPath: Binding<NavigationPath>, selectedTab: Binding<Int>) {
        self._viewModel = StateObject(wrappedValue: TasksViewModel(profile: profile))
        self._navigationPath = navigationPath
        self._selectedTab = selectedTab
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            header
            taskCard
            currentTaskLink
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(false)
        .preferredColorScheme(viewModel.profile.theme.colorScheme)
        .onAppear { logAppear() }
        .toolbar { toolbarContent }
    }
}

// MARK: - Subviews & Components
private extension TasksView {
    
    // MARK: Header
    var header: some View {
        Text("Урок 1")
            .font(.system(.largeTitle).weight(.semibold))
            .foregroundColor(Color("AppRed"))
    }

    // MARK: Task Card
    var taskCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color("TaskGray"))

            VStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color("TaskRectangle"))
                    .frame(maxHeight: 107)

                RoundedRectangle(cornerRadius: 30)
                    .fill(Color("TaskRectangle"))
                    .frame(maxHeight: 299)
                    .overlay { taskDescription }
            }
            .padding()
        }
    }

    var taskDescription: some View {
        Text(
            "После завершения урока, вы получите 200 очков опыта, а также 15 очков рейтинга.\n\n\nС помощью очков опыта, вы сможете улучшить свой профиль через раздел \(Text("магазин").foregroundColor(Color("AppRed"))).\n\nВы можете посмотреть свой рейтинг во вкладке \(Text("рейтинг").foregroundColor(Color("AppRed"))), чем больше вы учитесь, тем выше становитесь!"
        )
        .font(.system(size: 14))
        .multilineTextAlignment(.center)
        .opacity(0.6)
        .padding()
    }

    // MARK: Navigation Link to Task
    @ViewBuilder
    var currentTaskLink: some View {
        if let _ = viewModel.currentTask {
            NavigationLink(destination: TaskDetailView(viewModel: viewModel, navigationPath: $navigationPath)) {
                Text(Image(systemName: "play.fill"))
                    .font(.system(size: 23))
                    .padding()
                    .frame(maxWidth: 202)
                    .frame(maxHeight: 60)
                    .background(Color("AppRed"))
                    .foregroundColor(.white)
                    .cornerRadius(15)
                    .padding(.bottom, 20)
            }
        }
    }

    // MARK: Toolbar
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            statView(icon: "star.fill", value: "\(viewModel.profile.profile.points)")
        }
    }

    // MARK: Stat View
    @ViewBuilder
    func statView(icon: String, value: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .imageScale(.small)
                .foregroundColor(Color("AppRed"))
            Text(value)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(.thinMaterial, in: Capsule())
    }

    // MARK: Logging
    func logAppear() {
        print("TasksView: Appeared, level: \(viewModel.profile.profile.level), current task: \(viewModel.currentTask?.question ?? "none")")
    }
}

// MARK: - TaskDetailView
struct TaskDetailView: View {
    @ObservedObject var viewModel: TasksViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var navigationPath: NavigationPath

    // MARK: Body
    var body: some View {
        VStack(spacing: 20) {
            
            // Прогресс по заданиям
            ProgressBarView(progress: viewModel.progress)

            HStack {
                Spacer()
                Text("Скоро добавлю возможность использования доски")
                    .font(.system(size: 8))
                    .frame(maxWidth: 90, maxHeight: 70)
                    .foregroundStyle(Color("AppRed"))
            }
            
            Spacer()
            
            if let task = viewModel.currentTask {
                taskHeader(task: task)
                taskQuestion(task: task)
                Spacer()
                taskOptions(task: task)
            } else {
                noTaskView
            }
        }
        .padding()
        .navigationTitle("Задача")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar { taskToolbar }
        .alert(isPresented: $viewModel.showResult) { taskAlert }
        .preferredColorScheme(viewModel.profile.theme.colorScheme)
        .onAppear { logAppear() }
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
                .padding(.horizontal)
                .animation(.easeIn(duration: 0.3), value: progress)
        }
    }
    
    
    var taskToolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
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
            .padding()
            .background(RoundedRectangle(cornerRadius: 15).stroke(Color.primary, lineWidth: 2))
    }

    @ViewBuilder
    func taskOptions(task: Task) -> some View {
        ForEach(task.options ?? [], id: \.self) { option in
            Button(action: {
                viewModel.selectedAnswer = option
                viewModel.checkAnswer()
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
            Text("Задачи скоро добавлю")
                .font(.system(.title2))
                .foregroundColor(Color("AppRed"))

            Button(action: { navigationPath = NavigationPath() }) {
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

// MARK: - Preview
struct TasksView_Previews: PreviewProvider {
    static var previews: some View {
        TasksView(profile: UserProfileViewModel(), navigationPath: .constant(NavigationPath()), selectedTab: .constant(0))
    }
}
