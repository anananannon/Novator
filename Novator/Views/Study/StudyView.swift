import SwiftUI
// MARK: - StudyView
struct StudyView: View {
    // MARK: - Observed & State Objects
    @ObservedObject var profile: UserProfileViewModel
    @State private var navigationPath = NavigationPath()
    @Binding var selectedTab: Int
    @State private var showPopover = false
    
    @State private var selectedLesson: Lesson? = nil

    
    // MARK: - Initialization
    init(profile: UserProfileViewModel,
         selectedTab: Binding<Int>) {
        self.profile = profile
        self._selectedTab = selectedTab
    };
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationPath) {
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(TaskManager.lessons.reversed().chunked(into: 10), id: \.self) { chunk in
                            VStack(spacing: 20) {
                                ForEach(chunk, id: \.id) { lesson in
                                    Button(action: {
                                        selectedLesson = lesson
                                    }, label: {
                                        RoundedRectangle(cornerRadius: 20)
                                            .fill(profile.isLessonCompleted(lesson.id) ? Color("AppRed") : Color(.gray))
                                            .frame(minWidth: 30, minHeight: 30)
                                            .frame(maxWidth: 70, maxHeight: 70)
                                            .aspectRatio(1, contentMode: .fit)
                                            .overlay {
                                                Text("\(lesson.id)")
                                                    .font(.headline)
                                                    .foregroundColor(profile.isLessonCompleted(lesson.id) ? Color(.white) : .primary)
                                            }
                                    })
                                }
                            }
                            
                            if chunk != TaskManager.lessons.reversed().chunked(into: 10).last {
                                Divider()
                                    .frame(minHeight: 1.5)
                                    .overlay(Color("AppRed"))
                                    .padding(.horizontal, 10)
                            }
                        }

                    }
                    .frame(maxWidth: .infinity, minHeight: geometry.size.height) // Устанавливаем минимальную высоту
                    .padding()
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
    // MARK: - Toolbar Content
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
}
// MARK: - Preview
struct StudyView_Previews: PreviewProvider {
    static var previews: some View {
        StudyView(
            profile: UserProfileViewModel(),
            selectedTab: .constant(0)
        )
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
