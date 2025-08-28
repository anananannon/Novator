import SwiftUI

// MARK: - StudyView
struct StudyView: View {
    // MARK: - Observed & State Objects
    @ObservedObject var profile: UserProfileViewModel
    @StateObject private var viewModel: TasksViewModel
    @Binding var navigationPath: NavigationPath
    @Binding var selectedTab: Int
    @State private var showPopover = false
    
    // MARK: - Initialization
    init(profile: UserProfileViewModel,
         navigationPath: Binding<NavigationPath>,
         selectedTab: Binding<Int>) {
        self.profile = profile
        self._viewModel = StateObject(wrappedValue: TasksViewModel(profile: profile))
        self._navigationPath = navigationPath
        self._selectedTab = selectedTab
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                Spacer()
                
                currentTaskLink
                
                Spacer()
                
                NavigationLink(value: StudyDestination.tasks) {
                    PrimaryButton(title: "Решать задачи")
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: StudyDestination.self) { navigationDestination(for: $0) }
            .toolbar { toolbarContent }
        }
        .preferredColorScheme(profile.theme.colorScheme)
    }
}

// MARK: - Subviews & ViewBuilders
private extension StudyView {
    
    // MARK: - Current Task Navigation Link
    @ViewBuilder
    var currentTaskLink: some View {
        if viewModel.currentTask != nil {
            NavigationLink {
                TaskDetailView(viewModel: viewModel, navigationPath: $navigationPath)
            } label: {
                Image(systemName: "play.fill")
                    .font(.largeTitle)
            }
        } else {
            EmptyView()
        }
    }
    
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
            }
        }
    }
    
    // MARK: - Navigation Destination Builder
    @ViewBuilder
    func navigationDestination(for destination: StudyDestination) -> some View {
        switch destination {
        case .levelTest:
            LevelTestView(profile: profile, navigationPath: $navigationPath)
        case .tasks:
            TasksView(profile: profile, navigationPath: $navigationPath)
        }
    }
}

// MARK: - Preview
struct StudyView_Previews: PreviewProvider {
    static var previews: some View {
        StudyView(
            profile: UserProfileViewModel(),
            navigationPath: .constant(NavigationPath()),
            selectedTab: .constant(0)
        )
    }
}
