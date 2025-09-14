import SwiftUI

// MARK: - StudyView
@MainActor
struct StudyView: View {
    // MARK: - Observed & State
    @StateObject private var viewModel: StudyViewModel
    @Binding var selectedTab: Int
    
    @State var showingPage = false
    
    // MARK: - Init
    init(profile: UserProfileViewModel, selectedTab: Binding<Int>) {
        self._viewModel = StateObject(wrappedValue: StudyViewModel(profile: profile))
        self._selectedTab = selectedTab
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $viewModel.navigationPath) {
            GeometryReader { geometry in
                ScrollViewReader { proxy in
                    ZStack(alignment: .top) {
                        // Наверху — панель переключения страниц
                        
                        Button {
                            showingPage.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius: 13).fill(.thinMaterial)
                                .frame(height: 100)
                                .overlay {
                                    VStack {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                
                                                
                                                
                                                Text("\(viewModel.completedCountOnPage)/50")
                                                       .font(.system(size: 17, design: .monospaced))
                                                       .foregroundColor(.primary)
                                                   Text("Вы на \(viewModel.currentPage + 1) стадии")
                                                       .font(.system(size: 15))
                                                       .foregroundColor(.secondary)
                                            }
                                            Spacer()
                                            Image("rocketSV")
                                                .frame(width: 35, height: 35)
                                            
                                            
                                        }
                                        ProgressView(
                                            value: Double(viewModel.completedCountOnPage),
                                            total: Double(viewModel.totalCountOnPage)
                                        )
                                        .frame(maxWidth: .infinity)
                                        .scaleEffect(y: 2.5)
                                    }
                                    .padding(.horizontal, 10)
                                }
                        }
                        .buttonStyle(.plain)
                        .padding(.all, 10)
                        .zIndex(1)
                        
                        // Контент текущей страницы
                        ScrollView {
                            VStack(spacing: 20) {
                                Color(.black).opacity(0.000001)
                                    .frame(height: 105)
                                
                                ForEach(Array(viewModel.currentLessons.enumerated()), id: \.offset) { index, lesson in
                                    VStack(spacing: 20) {
                                        if viewModel.shouldShowDivider(before: lesson) {
                                            HStack {
                                                Rectangle()
                                                    .frame(height: 1.5)
                                                    .foregroundColor(Color("AppRed"))
                                                    .frame(maxWidth: .infinity)
                                                Text("\(Int(lesson.id) ?? 10) LVL")
                                                    .foregroundColor(Color("AppRed"))
                                                    .font(.system(size: 16, weight: .medium))
                                                Rectangle()
                                                    .frame(height: 1.5)
                                                    .foregroundColor(Color("AppRed"))
                                                    .frame(maxWidth: .infinity)
                                            }
                                        }
                                        
                                        LessonRow(
                                            lesson: lesson,
                                            index: index,
                                            isEvenIndex: index.isMultiple(of: 2),
                                            isExpanded: viewModel.activeButtons.contains(lesson.id),
                                            nextIncompleteLessonId: viewModel.nextIncompleteLessonId,
                                            isCompleted: viewModel.profile.isLessonCompleted(lesson.id),
                                            onTapSquare: { viewModel.handleSquareTap(for: lesson) }
                                        )
                                        .padding(.horizontal, 40)
                                        .id(lesson.id)
                                        .onAppear {
                                            print("🔔 Rendered lesson: id = \(lesson.id), index = \(index)")
                                        }
                                    }
                                }
                            }
                        }
                        .zIndex(0)
                        .animation(.spring(response: 0.2), value: viewModel.activeButtons)
                        .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar { toolbarContent }
                        .sheet(isPresented: $showingPage) {
                            showingPages(viewModel: viewModel)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture { if !viewModel.activeButtons.isEmpty { viewModel.resetActiveButtons() } }
                    .onAppear {
                        if !viewModel.hasScrolledOnFirstAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                print("🔔 onAppear: nextIncompleteLessonId = \(String(describing: viewModel.nextIncompleteLessonId))")
                                print("🔔 TaskManager.lessons: \(TaskManager.lessons.map { $0.id })")
                                if let targetId = viewModel.nextIncompleteLessonId {
                                    print("🔔 Прокрутка к уроку: \(targetId)")
                                    withAnimation(.spring(response: 0.2)) {
                                        proxy.scrollTo(targetId, anchor: .center)
                                    }
                                    viewModel.hasScrolledOnFirstAppear = true
                                } else {
                                    print("⚠️ Прокрутка не выполнена: nextIncompleteLessonId is nil")
                                }
                            }
                        } else {
                            print("🔔 onAppear: Прокрутка пропущена, так как уже выполнена")
                        }
                    }
                    .onChange(of: viewModel.nextIncompleteLessonId) { newValue in
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
        .fullScreenCover(item: $viewModel.selectedLesson) { lesson in
            TaskDetailView(
                profile: viewModel.profile,
                lessonId: lesson.id,
                lessonStars: lesson.lessonStars,
                lessonRaitingPoints: lesson.lessonRaitingPoints
            )
            .onDisappear {
                viewModel.resetActiveButtons()
                viewModel.updateNextIncompleteLessonId()
            }
        }
        .preferredColorScheme(viewModel.profile.theme.colorScheme)
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

// MARK: - Toolbar
private extension StudyView {
    @ToolbarContentBuilder
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button { viewModel.showStarsPopover.toggle() } label: {
                StatView(icon: "star.fill", value: "\(viewModel.profile.profile.stars)")
            }
            .popover(isPresented: $viewModel.showStarsPopover) {
                Text("Очки опыта - вы можете потратить их в магазине украшений профиля.")
                    .padding()
                    .foregroundColor(Color("AppRed"))
                    .frame(maxWidth: 210, minHeight: 90)
                    .presentationCompactAdaptation(.popover)
            }
        }
        
        ToolbarItem(placement: .topBarTrailing) {
            Button { viewModel.showRaitingPopover.toggle() } label: {
                StatView(icon: "crown.fill", value: "\(viewModel.profile.profile.raitingPoints)")
            }
            .popover(isPresented: $viewModel.showRaitingPopover) {
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
    let index: Int
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
    
    func content(alignment: HorizontalAlignmentEdge) -> some View {
        ZStack(alignment: alignment == .leading ? .leading : .trailing) {
            StatsOverlay(
                stars: lesson.lessonStars,
                crowns: lesson.lessonRaitingPoints,
                isVisible: isExpanded,
                anchor: alignment == .leading ? .leading : .trailing
            )
            
            LessonSquare(
                index: index,
                isCompleted: isCompleted,
                isNextIncomplete: (lesson.id == nextIncompleteLessonId),
                isExpanded: isExpanded,
                isEvenIndex: isEvenIndex,
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
    let index: Int
    let isCompleted: Bool
    let isNextIncomplete: Bool
    let isExpanded: Bool
    let isEvenIndex: Bool
    let action: () -> Void
    
    private var symbolName: String {
        if isExpanded {
            return isEvenIndex ? "arrowtriangle.right.fill" : "arrowtriangle.left.fill"
        } else {
            let symbolCycle = ["x.squareroot", "sum", "function"]
            return symbolCycle[index % 3]
        }
    }
    
    var body: some View {
        Button(action: action) {
            RoundedRectangle(cornerRadius: UIConstants.squareCornerRadius)
                .fill(fillColor)
                .frame(width: UIConstants.lessonSquareSize, height: UIConstants.lessonSquareSize)
                .scaleEffect(isNextIncomplete ? 1 : 0.96)
                .overlay {
                    Image(systemName: symbolName)
                        .font(.system(size: 20))
                        .foregroundColor(textColor)
                        .contentTransition(.symbolEffect(.replace, options: .speed(2)))
                }
        }
        .animation(.spring(response: 0.3), value: isNextIncomplete)
        .accessibilityAddTraits(.isButton)
        .accessibilityLabel("Урок с символом \(symbolName)")
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

private struct showingPages: View {
    
    @ObservedObject var viewModel: StudyViewModel
    
    var body: some View {
        
        VStack {
            Text("123")
            Spacer()
            HStack {
                Button {
                    viewModel.goToPreviousPage()
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(viewModel.currentPage == 0 ? Color(.systemGray4) : Color("AppRed"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .overlay {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                }
                .disabled(viewModel.currentPage == 0)
                Button {
                    viewModel.goToNextPage()
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(viewModel.currentPage + 1 >= viewModel.lessonsByPage.count ? Color(.systemGray4) : Color("AppRed"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .overlay {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                }
                .disabled(viewModel.currentPage + 1 >= viewModel.lessonsByPage.count)
            }
        }
        .padding(.horizontal, 30)
        .presentationDetents([.height(500)])
        .presentationCornerRadius(20)
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
