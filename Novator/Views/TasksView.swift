import SwiftUI
import Foundation

struct TasksView: View {
    @StateObject private var viewModel: TasksViewModel
    @Binding var navigationPath: NavigationPath
    @Environment(\.dismiss) private var dismiss
    
    init(profile: UserProfileViewModel, navigationPath: Binding<NavigationPath>) {
        self._viewModel = StateObject(wrappedValue: TasksViewModel(profile: profile))
        self._navigationPath = navigationPath
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Урок 1")
                .font(.system(.largeTitle).weight(.semibold))
                .foregroundColor(Color("AppRed"))
            
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
                        .overlay {
                            Text("После завершения урока, вы получите 200 очков опыта, а также 15 очков рейтинга.\n\n\nС помощью очков опыта, вы сможете улучшить свой профиль через раздел \(Text("магазин").foregroundColor(Color("AppRed"))).\n\nВы можете посмотреть свой рейтинг во вкладке \(Text("рейтинг").foregroundColor(Color("AppRed"))), чем больше вы учитесь, тем выше становитесь!")
                                .font(.system(size: 14))
                                .multilineTextAlignment(.center)
                                .opacity(0.6)
                                .padding()
                        }
                }
                .padding()
            }
            
           
            
            if let task = viewModel.currentTask {
                NavigationLink(destination: TaskDetailView(viewModel: viewModel)) {
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
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // убираем "< Назад"
        .preferredColorScheme(viewModel.profile.theme.colorScheme)
        .onAppear {
            print("TasksView: Appeared, level: \(viewModel.profile.profile.level), current task: \(viewModel.currentTask?.question ?? "none")")
        }
        .toolbar {
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
            ToolbarItem(placement: .topBarTrailing) {
                statView(icon: "star.fill", value: "\(viewModel.profile.profile.points)")
            }
        }
    }
    
    @ViewBuilder
    private func statView(icon: String, value: String) -> some View {
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
}

struct TaskDetailView: View {
    @ObservedObject var viewModel: TasksViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer()
            if let task = viewModel.currentTask {
                Text(task.isLogicalTrick ? "Логическая задача" : "Математическая задача")
                    .font(.system(.subheadline))
                    .foregroundColor(.gray)
                
                
                Text(task.question)
                    .font(.system(.title2))
                    .foregroundColor(Color("AppRed"))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).stroke(Color.primary, lineWidth: 2))
                
                Spacer()
                
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
                
            } else {
                Text("Задачи скоро добавлю")
                    .font(.system(.title2))
                    .foregroundColor(Color("AppRed"))
                
                Spacer()
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
