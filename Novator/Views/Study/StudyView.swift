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
                
                NavigationLink {
                    TaskDetailView(profile: profile, navigationPath: $navigationPath)
                } label : {
                    PrimaryButton(title: "Начать решать задачи")
                }
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
            .preferredColorScheme(viewModel.profile.theme.colorScheme)
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
