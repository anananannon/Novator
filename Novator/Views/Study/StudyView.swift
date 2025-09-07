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
    // Кэшируем id следующего незавершенного урока
    @State private var nextIncompleteLessonId: String?

    // MARK: - Initialization
    init(profile: UserProfileViewModel, selectedTab: Binding<Int>) {
        self.profile = profile
        self._selectedTab = selectedTab
        // Инициализируем nextIncompleteLessonId
        self._nextIncompleteLessonId = State(initialValue: TaskManager.lessons.sorted { Int($0.id) ?? 0 < Int($1.id) ?? 0 }.first { !profile.isLessonCompleted($0.id) }?.id)
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
                                                        VStack(alignment: .trailing) {
                                                            HStack(spacing: 6) {
                                                                Image(systemName: "star.fill")
                                                                    .foregroundStyle(Color("AppRed"))
                                                                Text("\(lesson.lessonStars)")
                                                                    .font(.system(.headline, design: .monospaced))
                                                            }
                                                            HStack(spacing: 6) {
                                                                Image(systemName: "crown.fill")
                                                                    .foregroundStyle(Color("AppRed"))
                                                                Text("\(lesson.lessonRaitingPoints)")
                                                                    .font(.system(.headline, design: .monospaced))
                                                            }
                                                        }
                                                        .padding(.horizontal, 20)
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
                                                        VStack(alignment: .trailing) {
                                                            HStack(spacing: 6) {
                                                                Image(systemName: "star.fill")
                                                                    .foregroundStyle(Color("AppRed"))
                                                                Text("\(lesson.lessonStars)")
                                                                    .font(.system(.headline, design: .monospaced))
                                                            }
                                                            HStack(spacing: 6) {
                                                                Image(systemName: "crown.fill")
                                                                    .foregroundStyle(Color("AppRed"))
                                                                Text("\(lesson.lessonRaitingPoints)")
                                                                    .font(.system(.headline, design: .monospaced))
                                                            }
                                                        }
                                                        .padding(.horizontal, 20)
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
                    // Обновляем nextIncompleteLessonId после завершения урока
                    nextIncompleteLessonId = TaskManager.lessons.sorted { Int($0.id) ?? 0 < Int($1.id) ?? 0 }.first { !profile.isLessonCompleted($0.id) }?.id
                }
        }
        .preferredColorScheme(profile.theme.colorScheme)
    }
}

// MARK: - Subviews & ViewBuilders
private extension StudyView {
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                showPopover.toggle()
            } label: {
                StatView(icon: "star.fill", value: "\(profile.profile.stars)")
            }
            .popover(isPresented: $showPopover) {
                Text("С помощью очков опыта магазина вы можете приобретать уникальные вещи для вашего профиля, а так же дарить подарки друзьям.")
                    .padding()
                    .foregroundColor(Color("AppRed"))
                    .frame(maxWidth: 250, minHeight: 90)
                    .presentationCompactAdaptation(.popover)
            }
            .preferredColorScheme(profile.theme.colorScheme)
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                // Действие для рейтинга
            } label: {
                StatView(icon: "crown.fill", value: "\(profile.profile.raitingPoints)")
            }
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
                    .fill({
                        if profile.isLessonCompleted(lesson.id) {
                            return Color("AppRed") // Завершенные уроки — красные
                        } else if lesson.id == nextIncompleteLessonId {
                            return Color("AppRed") // Следующий незавершенный урок — красный
                        } else {
                            return Color(.gray) // Остальные незавершенные — серые
                        }
                    }())
                    .frame(width: 90, height: 90)
                    .scaleEffect(lesson.id == nextIncompleteLessonId ? 1 : 0.96)
                    .animation(.spring(response: 0.3), value: nextIncompleteLessonId)
                    .overlay {
                        Text("\(lesson.id)")
                            .font(.headline)
                            .foregroundColor(profile.isLessonCompleted(lesson.id) || lesson.id == nextIncompleteLessonId ? .white : .primary)
                    }
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 3)
            .disabled(lesson.id != nextIncompleteLessonId) // Отключаем все уроки, кроме следующего незавершенного
        }
    }
}

// MARK: - Preview
struct StudyView_Previews: PreviewProvider {
    static var previews: some View {
        StudyView(profile: UserProfileViewModel(), selectedTab: .constant(0))
    }
}
