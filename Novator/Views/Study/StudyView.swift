import SwiftUI

// MARK: - StudyView
struct StudyView: View {
    // MARK: - Observed & State Objects
    @ObservedObject var profile: UserProfileViewModel
    @State private var navigationPath = NavigationPath()
    @Binding var selectedTab: Int
    @State private var showPopover = false
    @State private var selectedLesson: Lesson? = nil
    
    @State private var isTapButton = false
    
    
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
                    LazyVStack(spacing: 20) { // <-- LazyVStack вместо VStack
                        ForEach(TaskManager.lessons.reversed().chunked(into: 10), id: \.self) { chunk in
                            LazyVStack(spacing: 20) { // вложенный LazyVStack
                                ForEach(chunk.indices, id: \.self) { index in
                                    let lesson = chunk[index]
                                    HStack {
                                        if index % 2 == 0 {
                                            ZStack(alignment: .leading) {
                                                RoundedRectangle(cornerRadius: 23).fill(Color("TaskBackground"))
                                                    .frame(height: 76)
                                                    .frame(minWidth: 200)
                                                    .opacity(isTapButton ? 1:0)
                                                    .scaleEffect(x: isTapButton ? 1 : 0, anchor: .leading)
                                                
                                                lessonButton(lesson)
                                            }
                                            Spacer()
                                        } else {
                                            Spacer()
                                            ZStack(alignment: .trailing) {
                                                RoundedRectangle(cornerRadius: 23).fill(Color("TaskBackground"))
                                                    .frame(height: 76)
                                                    .frame(minWidth: 200)
                                                    .opacity(isTapButton ? 1:0)
                                                    .scaleEffect(x: isTapButton ? 1 : 0, anchor: .trailing)
                                                lessonButton(lesson)
                                            }
                                        }
                                    }
                                }
                            }

                            if chunk != TaskManager.lessons.reversed().chunked(into: 10).last {
                                Divider()
                                    .frame(height: 1.5)
                                    .background(Color("AppRed"))
                                    .padding(.horizontal, 10)
                            }
                        }
                    }
                    .animation(.linear(duration: 0.2), value: isTapButton)
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                    .padding()
                    .padding(.horizontal, 40    )
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar { toolbarContent }
                }
            }
        }
        .fullScreenCover(item: $selectedLesson) { lesson in
            TaskDetailView(profile: profile, lessonId: lesson.id)
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
                if isTapButton {
                    selectedLesson = lesson
                } else {
                    isTapButton.toggle()
                }
            }) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(profile.isLessonCompleted(lesson.id) ? Color("AppRed") : Color(.gray))
                    .frame(width: 70, height: 70)
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

// Helper: разбиваем массив на чанки по N элементов
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
