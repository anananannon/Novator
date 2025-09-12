import SwiftUI
import Foundation

// MARK: - TaskDetailView
struct TaskDetailView: View {
    @StateObject private var viewModel: TasksViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var systemColorScheme
    @State private var showContent = false
    @State private var showAcceptSheet = false
    @State private var showNoTaskView = false // Состояние для анимации noTaskView
    let lessonId: String
    let lessonStars: Int
    let lessonRaitingPoints: Int
    
    init(profile: UserProfileViewModel, lessonId: String, lessonStars: Int, lessonRaitingPoints: Int) {
        self.lessonId = lessonId
        self.lessonStars = lessonStars
        self.lessonRaitingPoints = lessonRaitingPoints
        self._viewModel = StateObject(wrappedValue: TasksViewModel(profile: profile, lessonId: lessonId))
    }
    
    var body: some View {
        ZStack {
            backgroundView
            contentView
                .offset(x: showContent ? 0 : UIScreen.main.bounds.width) // старт за экраном справа !!!Этот комментарий не убирать
                .opacity(showContent ? 1 : 0) // добавляем плавное появление !!!Этот комментарий не убирать
                .animation(.easeInOut(duration: 0.4).delay(0.2), value: showContent) // анимация въезда !!!Этот комментарий не убирать
        }
        .onAppear {
            print("🔔 TaskDetailView: onAppear triggered, currentTask = \(String(describing: viewModel.currentTask))")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showContent = true
                if viewModel.currentTask == nil {
                    print("🔔 TaskDetailView: No tasks available, showing noTaskView")
                    showNoTaskView = true
                }
            }
            viewModel.logAppear()
        }
        .onChange(of: viewModel.currentTask) { newValue in
            print("🔔 TaskDetailView: currentTask changed to \(String(describing: newValue))")
            showNoTaskView = newValue == nil
        }
        .sheet(isPresented: $showAcceptSheet) { acceptSheetContent }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(viewModel.profile.theme.colorScheme)
    }
}

// MARK: - Views
private extension TaskDetailView {
    var backgroundView: some View {
        Group {
            if viewModel.profile.theme.colorScheme == .light || (viewModel.profile.theme == .system && systemColorScheme == .light) {
                Color.white.ignoresSafeArea() // 1. Белый фон сразу !!!Этот комментарий не убирать
            } else {
                Color.black.ignoresSafeArea()
            }
        }
        .onAppear {
            print("🔔 TaskDetailView: backgroundView rendered, theme = \(viewModel.profile.theme), systemColorScheme = \(systemColorScheme)")
        }
    }
    
    var contentView: some View {
        VStack(spacing: 20) {
            if let task = viewModel.currentTask {
                headerView
                Spacer()
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
        .onAppear {
            print("🔔 TaskDetailView: contentView rendered, showContent = \(showContent)")
        }
    }
    
    var acceptSheetContent: some View {
        VStack {
            Image(systemName: "questionmark.app")
                .font(.system(size: 100))
                .foregroundColor(Color("AppRed"))
            
            Spacer()
            
            Text("Вы уверены?")
                .font(.system(size: 24, weight: .semibold))
                .padding(.horizontal, 50)
            
            Spacer()
            
            Button {
                dismiss()
            } label: {
                Text("Выйти")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(minWidth: 300, minHeight: 55)
            }
            .buttonStyle(PrimaryButtonStyle())
            
            Spacer()
            
            Button {
                showAcceptSheet.toggle()
            } label: {
                Text("Остаться")
                    .foregroundColor(.primary)
                    .fontWeight(.semibold)
                    .underline()
            }
        }
        .padding(.vertical, 20)
        .presentationDetents([.height(300)])
        .presentationCornerRadius(20)
    }
    
    // MARK: - Header
    var headerView: some View {
        HStack {
            Button {
                showAcceptSheet.toggle()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(.title))
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding(6)
            }
            VStack(alignment: .leading) {
                ProgressBarView(progress: viewModel.progress)
                    .frame(maxWidth: .infinity)
                Text(viewModel.progressText)
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .padding(.top, 3)
            }
        }
        .padding()
    }
    
    // MARK: - Task Content
    func taskContentView(task: AppTask) -> some View {
        VStack {
            taskQuestion(task: task)
                .padding(.bottom, 30)
            taskOptions(task: task)
            resultAndActionView
        }
        .padding()
    }
    
    // MARK: - Result & Action
    var resultAndActionView: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 19)
                .fill(viewModel.resultColor)
                .frame(minWidth: 340, maxHeight: 160)
                .overlay(resultOverlay)
                .opacity(viewModel.showResult ? 1 : 0)
                .scaleEffect(y: viewModel.showResult ? 1 : 0, anchor: .bottom)
                .animation(.spring(response: 0.3), value: viewModel.showResult)
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
            Text("\(Image(systemName: viewModel.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")) \(viewModel.resultText)")
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
    
    // MARK: - No Task
    var noTaskView: some View {
        VStack(spacing: 14) {
            Text("Урок выполнен!")
                .font(.system(size: 25))
                .foregroundColor(Color("AppRed"))
                .padding(.top, 20)
                
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color("AppRed"), lineWidth: 1)
                .frame(width: 310, height: 395)
                .overlay {
                    VStack(spacing: 0) {
                        Color("AppRed") // Тут надо убрать нижние радиусы
                            .cornerRadius(30, corners: [.topLeft, .topRight]) // только верхние углы
                            .frame(width: 310, height: 96)
                            .overlay {
                                Text("NOVATOR\nPREMIUM")
                                    .font(.system(size: 26, weight: .heavy))
                                    .foregroundColor(Color.invertedPrimary(systemColorScheme))
                            }
                        Spacer()
                        Image("rocketNoTaskView")
                            .frame(width: 248, height: 248)
                            .padding(.bottom, 20)
                    }
                }
                .padding(.top, 60)
            Button("Отключить рекламу") {
                print("🔔 TaskDetailView: Отключить рекламу tapped")
            }
            .font(.system(size: 13, weight: .medium))
            .underline()
            .foregroundColor(.primary)
            
            Spacer()
            Button {
                dismiss()
            } label: {
                Label("Продолжить", systemImage: "shippingbox.fill")
                    .font(.system(.title2))
                    .frame(maxWidth: 250, maxHeight: 50)
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .opacity(showNoTaskView ? 1 : 0) // Плавное появление
        .animation(.spring(response: 1).delay(0.8), value: showNoTaskView) // Плавная анимация
        .onAppear {
            print("🔔 TaskDetailView: noTaskView rendered, showNoTaskView = \(showNoTaskView)")
        }
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
    
    func taskQuestion(task: AppTask) -> some View {
        Text(task.question)
            .font(.system(.title3, design: .monospaced))
            .fontWeight(.semibold)
            .frame(minWidth: 340, minHeight: 98)
            .background(Color("TaskBackground"))
            .foregroundColor(.primary)
            .cornerRadius(16)
    }
    
    @ViewBuilder
    func taskOptions(task: AppTask) -> some View {
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
                .buttonStyle(.plain)
                .disabled(viewModel.showResult) // визуально блокируем
            }
        }
    }
}

// MARK: - Color Extension
extension Color {
    static func invertedPrimary(_ systemColorScheme: ColorScheme) -> Color {
        systemColorScheme == .light ? .white : .black
    }
}
