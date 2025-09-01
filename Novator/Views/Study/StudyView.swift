import SwiftUI
// MARK: - StudyView
struct StudyView: View {
    // MARK: - Observed & State Objects
    @ObservedObject var profile: UserProfileViewModel
    @State private var navigationPath = NavigationPath()
    @Binding var selectedTab: Int
    @State private var showPopover = false
    // MARK: - Initialization
    init(profile: UserProfileViewModel,
         selectedTab: Binding<Int>) {
        self.profile = profile
        self._selectedTab = selectedTab
    };
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                Spacer()
                ForEach(TaskManager.lessons, id: \.id) { lesson in
                    NavigationLink(destination: TaskDetailView(profile: profile, lessonId: lesson.id)) {
                        HStack {
                            Text(lesson.name)
                                .font(.system(.title3))
                            if profile.profile.completedLessons.contains(lesson.id) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .frame(maxWidth: 333.63, maxHeight: 47)
                        .background(Color("AppRed"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
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
