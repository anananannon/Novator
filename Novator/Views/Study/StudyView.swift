import SwiftUI

// MARK: - StudyView
struct StudyView: View {
    // MARK: - Observed & State Objects
    @ObservedObject var profile: UserProfileViewModel
    @StateObject private var viewModel: TasksViewModel
    @State private var navigationPath = NavigationPath()
    @Binding var selectedTab: Int
    
    @State private var showPopover = false
    @State private var showTasks = false
    
    // MARK: - Initialization
    init(profile: UserProfileViewModel,
         selectedTab: Binding<Int>) {
        self.profile = profile
        self._viewModel = StateObject(wrappedValue: TasksViewModel(profile: profile))
        self._selectedTab = selectedTab
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                Spacer()
                
                Button {
                    showTasks = true
                } label: {
                    Text("Начать решать задание")
                        .font(.system(.title3))
                        .frame(maxWidth: 333.63, maxHeight: 47)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
        }
        .preferredColorScheme(profile.theme.colorScheme)
        .fullScreenCover(isPresented: $showTasks) {
            TaskDetailView(profile: profile)
        }
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
            .preferredColorScheme(viewModel.profile.theme.colorScheme)
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
