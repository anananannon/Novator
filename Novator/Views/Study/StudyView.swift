import SwiftUI

// MARK: - StudyView
@MainActor
struct StudyView: View {
    // MARK: Observed & State
    @ObservedObject var profile: UserProfileViewModel
    @Binding var selectedTab: Int

    @State private var navigationPath = NavigationPath()
    @State private var showStarsPopover = false
    @State private var showRaitingPopover = false
    @State private var selectedLesson: Lesson? = nil
    @State private var activeButtons: Set<String> = []
    @State private var nextIncompleteLessonId: String?
    @State private var hasScrolledOnFirstAppear = false // Флаг для первого появления

    // MARK: Init
    init(profile: UserProfileViewModel, selectedTab: Binding<Int>) {
        self.profile = profile
        self._selectedTab = selectedTab
        self._nextIncompleteLessonId = State(initialValue: Self.computeNextIncompleteLessonId(for: profile))
    }

    // MARK: Body
    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geometry in
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 20) { // Используем VStack, как в рабочей версии
                            let lessons = reversedLessons
                            ForEach(Array(lessons.enumerated()), id: \.offset) { index, lesson in
                                VStack(spacing: 20) {
                                    if shouldShowDivider(before: lesson) {
                                        Divider()
                                            .frame(height: 1.5)
                                            .background(Color("AppRed"))
                                            .padding(.horizontal, 10)
                                    }
                                    
                                    LessonRow(
                                        lesson: lesson,
                                        isEvenIndex: index.isMultiple(of: 2),
                                        isExpanded: activeButtons.contains(lesson.id),
                                        nextIncompleteLessonId: nextIncompleteLessonId,
                                        isCompleted: profile.isLessonCompleted(lesson.id),
                                        onTapSquare: { handleSquareTap(for: lesson) }
                                    )
                                    .padding(.horizontal, 30)
                                    .id(lesson.id)
                                    .onAppear {
                                        print("🔔 Rendered lesson: id = \(lesson.id), index = \(index)")
                                    }
                                }
                            }
                        }
                        .animation(.spring(response: 0.2), value: activeButtons)
                        .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                        .padding()
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar { toolbarContent }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { if !activeButtons.isEmpty { activeButtons.removeAll() } }
                    .onAppear {
                        // Прокрутка только при первом появлении
                        if !hasScrolledOnFirstAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                print("🔔 onAppear: nextIncompleteLessonId = \(String(describing: nextIncompleteLessonId))")
                                print("� Bellamy TaskManager.lessons: \(TaskManager.lessons.map { $0.id })")
                                if let targetId = nextIncompleteLessonId {
                                    print("🔔 Прокрутка к уроку: \(targetId)")
                                    withAnimation(.spring(response: 0.2)) {
                                        proxy.scrollTo(targetId, anchor: .bottom)
                                    }
                                    hasScrolledOnFirstAppear = true // Отмечаем, что прокрутка выполнена
                                } else {
                                    print("⚠️ Прокрутка не выполнена: nextIncompleteLessonId is nil")
                                }
                            }
                        } else {
                            print("🔔 onAppear: Прокрутка пропущена, так как уже выполнена")
                        }
                    }
                    .onChange(of: nextIncompleteLessonId) { newValue in
                        // Прокрутка при изменении nextIncompleteLessonId (после завершения урока)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            print("🔔 onChange: nextIncompleteLessonId = \(String(describing: newValue))")
                            if let targetId = newValue {
                                print("🔔 Прокрутка к уроку: \(targetId)")
                                withAnimation(.spring(response: 0.04)) {
                                    proxy.scrollTo(targetId, anchor: .center)
                                }
                            } else {
                                print("⚠️ Прокрутка не выполнена: nextIncompleteLessonId is nil")
                            }
                        }
                    }
                }
            }
        }
        .fullScreenCover(item: $selectedLesson) { lesson in
            TaskDetailView(profile: profile, lessonId: lesson.id)
                .onDisappear {
                    activeButtons.removeAll()
                    nextIncompleteLessonId = Self.computeNextIncompleteLessonId(for: profile)
                }
        }
        .preferredColorScheme(profile.theme.colorScheme)
    }
}

// MARK: - UI Constants
private enum UIConstants {
    static let lessonSquareSize: CGFloat = 90
    static let lessonRowHeight: CGFloat = 96
    static let lessonRowMaxWidth: CGFloat = 230
    static let cornerRadius: CGFloat = 23
    static let squareCornerRadius: CGFloat = 20
}

// MARK: - Computeds & Helpers
private extension StudyView {
    var reversedLessons: [Lesson] {
        Array(TaskManager.lessons.reversed())
    }

    func shouldShowDivider(before lesson: Lesson) -> Bool {
        guard let id = Int(lesson.id) else { return false }
        return id % 10 == 0
    }

    static func computeNextIncompleteLessonId(for profile: UserProfileViewModel) -> String? {
        let incompleteLesson = TaskManager.lessons
            .sorted { (Int($0.id) ?? 0) < (Int($1.id) ?? 0) }
            .first { !profile.isLessonCompleted($0.id) }
        print("🔔 computeNextIncompleteLessonId: lessons count = \(TaskManager.lessons.count), incomplete lesson = \(String(describing: incompleteLesson?.id))")
        return incompleteLesson?.id
    }

    func handleSquareTap(for lesson: Lesson) {
        if activeButtons.contains(lesson.id) {
            selectedLesson = lesson
            activeButtons.removeAll()
        } else {
            activeButtons = [lesson.id]
        }
    }
}

// MARK: - Toolbar
private extension StudyView {
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button { showStarsPopover.toggle() } label: {
                StatView(icon: "star.fill", value: "\(profile.profile.stars)")
            }
            .popover(isPresented: $showStarsPopover) {
                Text("Очки опыта - вы можете потратить их в магазине украшений профиля.")
                    .padding()
                    .foregroundColor(Color("AppRed"))
                    .frame(maxWidth: 210, minHeight: 90)
                    .presentationCompactAdaptation(.popover)
            }
        }

        ToolbarItem(placement: .topBarTrailing) {
            Button { showRaitingPopover.toggle() } label: {
                StatView(icon: "crown.fill", value: "\(profile.profile.raitingPoints)")
            }
            .popover(isPresented: $showRaitingPopover) {
                Text("Очки рейтинга - с помощью них вы можете повышать свой рейтинг и получать уникальные подарки.")
                    .padding()
                    .foregroundColor(Color("AppRed"))
                    .frame(maxWidth: 230, minHeight: 116)
                    .presentationCompactAdaptation(.popover)
            }
        }
    }
}

// MARK: - LessonRow
private struct LessonRow: View {
    let lesson: Lesson
    let isEvenIndex: Bool
    let isExpanded: Bool
    let nextIncompleteLessonId: String?
    let isCompleted: Bool
    let onTapSquare: () -> Void

    var body: some View {
        HStack {
            if isEvenIndex {
                content(alignment: .leading)
                Spacer()
            } else {
                Spacer()
                content(alignment: .trailing)
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Урок \(lesson.id)")
    }
}

// MARK: - LessonRow UI
private extension LessonRow {
    func content(alignment: HorizontalAlignmentEdge) -> some View {
        ZStack(alignment: alignment == .leading ? .leading : .trailing) {
            StatsOverlay(
                stars: lesson.lessonStars,
                crowns: lesson.lessonRaitingPoints,
                isVisible: isExpanded,
                anchor: alignment == .leading ? .leading : .trailing
            )

            LessonSquare(
                idText: lesson.id,
                isCompleted: isCompleted,
                isNextIncomplete: (lesson.id == nextIncompleteLessonId),
                action: onTapSquare
            )
            .padding(.horizontal, 3)
            .disabled(lesson.id != nextIncompleteLessonId)
            .buttonStyle(.plain)
        }
    }
}

// MARK: - Supporting Views
private struct StatsOverlay: View {
    let stars: Int
    let crowns: Int
    let isVisible: Bool
    let anchor: UnitPoint

    var body: some View {
        RoundedRectangle(cornerRadius: UIConstants.cornerRadius)
            .fill(Color("TaskBackground"))
            .frame(height: UIConstants.lessonRowHeight)
            .frame(maxWidth: UIConstants.lessonRowMaxWidth)
            .overlay(alignment: .center) {
                HStack {
                    if anchor == .trailing { stats }
                    Spacer()
                    if anchor == .leading { stats }
                }
            }
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(x: isVisible ? 1 : 0, anchor: anchor)
            .animation(.spring(response: 0.2), value: isVisible)
    }

    private var stats: some View {
        VStack(alignment: .trailing) {
            HStack(spacing: 6) {
                Image(systemName: "star.fill").foregroundStyle(Color("AppRed"))
                Text("\(stars)").font(.system(.headline, design: .monospaced))
            }
            HStack(spacing: 6) {
                Image(systemName: "crown.fill").foregroundStyle(Color("AppRed"))
                Text("\(crowns)").font(.system(.headline, design: .monospaced))
            }
        }
        .padding(.horizontal, 20)
    }
}

private struct LessonSquare: View {
    let idText: String
    let isCompleted: Bool
    let isNextIncomplete: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: UIConstants.squareCornerRadius)
                .fill(fillColor)
                .frame(width: UIConstants.lessonSquareSize, height: UIConstants.lessonSquareSize)
                .scaleEffect(isNextIncomplete ? 1 : 0.96)
                .overlay { Text(idText).font(.headline).foregroundColor(textColor) }
        }
        .animation(.spring(response: 0.3), value: isNextIncomplete)
        .accessibilityAddTraits(.isButton)
    }

    private var fillColor: Color {
        if isCompleted { return Color("AppRed") }
        if isNextIncomplete { return Color("AppRed") }
        return Color(.gray)
    }

    private var textColor: Color {
        (isCompleted || isNextIncomplete) ? .white : .primary
    }
}

// MARK: - Utilities
private enum HorizontalAlignmentEdge { case leading, trailing }

// MARK: - Preview
struct StudyView_Previews: PreviewProvider {
    static var previews: some View {
        StudyView(profile: UserProfileViewModel(), selectedTab: .constant(0))
    }
}
