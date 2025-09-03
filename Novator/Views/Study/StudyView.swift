import SwiftUI

// MARK: - StudyView
struct StudyView: View {
    // MARK: - Observed & State Objects
    @ObservedObject var profile: UserProfileViewModel
    @State private var navigationPath = NavigationPath()
    @Binding var selectedTab: Int
    @State private var showPopover = false
    @State private var selectedLesson: Lesson? = nil
    // Словарь для отслеживания состояния нажатия кнопок, используем String для lesson.id
    @State private var buttonStates: [String: Bool] = [:]
    
    // MARK: - Initialization
    init(profile: UserProfileViewModel, selectedTab: Binding<Int>) {
        self.profile = profile
        self._selectedTab = selectedTab
    }

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geometry in
                ScrollView {
                    LazyVStack(spacing: 20) {
                        // Переворачиваем уроки, чтобы первые были внизу, и преобразуем в массив
                        let reversedLessons = Array(TaskManager.lessons.reversed())
                        ForEach(reversedLessons.indices, id: \.self) { index in
                            let lesson = reversedLessons[index]
                            VStack(spacing: 20) {
                                // Рисуем Divider перед уроком, если текущий lesson.id % 10 == 0
                                if let lessonId = Int(lesson.id), lessonId % 10 == 0 {
                                    Divider()
                                        .frame(height: 1.5)
                                        .background(Color("AppRed"))
                                        .padding(.horizontal, 10)
                                }
                                
                                HStack {
                                    if index % 2 == 0 {
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 23)
                                                .fill(Color("TaskBackground"))
                                                .frame(height: 96)
                                                .frame(maxWidth: 230)
                                                .overlay {
                                                    HStack {
                                                        Spacer()
                                                        Image(systemName: "star.fill")
                                                            .foregroundStyle(Color("AppRed"))
                                                        Text("\(lesson.lessonPoints)")
                                                            .font(.system(.headline, design: .monospaced))
                                                            .padding(.trailing, 30)
                                                    }
                                                }
                                                .opacity(buttonStates[lesson.id, default: false] ? 1 : 0)
                                                .scaleEffect(x: buttonStates[lesson.id, default: false] ? 1 : 0, anchor: .leading)
                                            
                                            lessonButton(lesson)
                                        }
                                        Spacer()
                                    } else {
                                        Spacer()
                                        ZStack(alignment: .trailing) {
                                            RoundedRectangle(cornerRadius: 23)
                                                .fill(Color("TaskBackground"))
                                                .frame(height: 96)
                                                .frame(maxWidth: 230)
                                                .overlay {
                                                    HStack {
                                                        Image(systemName: "star.fill")
                                                            .foregroundStyle(Color("AppRed"))
                                                            .padding(.leading, 30)
                                                        Text("\(lesson.lessonPoints)")
                                                            .font(.system(.headline, design: .monospaced))
                                                        Spacer()
                                                    }
                                                }
                                                .opacity(buttonStates[lesson.id, default: false] ? 1 : 0)
                                                .scaleEffect(x: buttonStates[lesson.id, default: false] ? 1 : 0, anchor: .trailing)
                                            lessonButton(lesson)
                                        }
                                    }
                                }
                                .padding(.horizontal, 30)
                            }
                        }
                    }
//                    .animation(.linear(duration: 0.2), value: buttonStates)
                    .animation(.spring(response: 0.2), value: buttonStates)
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                    .padding()
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { toolbarContent }
                }
                // Добавляем жест тапа на пустое место
                .contentShape(Rectangle()) // Убедимся, что ScrollView реагирует на тапы по всей площади
                .onTapGesture {
                    if !buttonStates.isEmpty {
                        buttonStates = [:] // Сбрасываем состояния кнопок при тапе на пустое место
                    }
                }
            }
        }
        .fullScreenCover(item: $selectedLesson) { lesson in
            TaskDetailView(profile: profile, lessonId: lesson.id)
                .onDisappear {
                    buttonStates = [:] // Сбрасываем все состояния после закрытия
                }
        }
        .preferredColorScheme(profile.theme.colorScheme)
    }
}

// MARK: - Subviews & ViewBuilders
private extension StudyView {
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                showPopover.toggle()
            } label: {
                StatView(icon: "star.fill", value: "\(profile.profile.points)")
            }
            .popover(isPresented: $showPopover) {
                Text("С помощью очков опыта вы можете повысить свой рейтинг и открыть уникальные фишки.")
                    .padding()
                    .foregroundColor(Color("AppRed"))
                    .frame(maxWidth: 250, minHeight: 90)
                    .presentationCompactAdaptation(.popover)
            }
            .preferredColorScheme(profile.theme.colorScheme)
        }
    }

    @ViewBuilder
    func lessonButton(_ lesson: Lesson) -> some View {
        ZStack(alignment: .leading) {
            Button(action: {
                if buttonStates[lesson.id, default: false] {
                    selectedLesson = lesson
                    buttonStates = [:] // Сбрасываем состояние перед открытием урока
                } else {
                    buttonStates = [lesson.id: true] // Сбрасываем все состояния и активируем только текущую кнопку
                }
            }) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(profile.isLessonCompleted(lesson.id) ? Color("AppRed") : Color(.gray))
                    .frame(width: 90, height: 90)
                    .overlay {
                        Text("\(lesson.id)")
                            .font(.headline)
                            .foregroundColor(profile.isLessonCompleted(lesson.id) ? .white : .primary)
                    }
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 3)
        }
    }
}

// MARK: - Preview
struct StudyView_Previews: PreviewProvider {
    static var previews: some View {
        StudyView(profile: UserProfileViewModel(), selectedTab: .constant(0))
    }
}
