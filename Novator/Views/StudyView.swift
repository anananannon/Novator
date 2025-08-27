import SwiftUI

// MARK: - Навигационные точки для Study
enum StudyDestination: String, Hashable {
    case levelTest
    case tasks
}

// MARK: - StudyView
struct StudyView: View {
    @ObservedObject var profile: UserProfileViewModel
    @State private var showPopover = false
    @Binding var navigationPath: NavigationPath
    @Binding var selectedTab: Int
    
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            content
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: StudyDestination.self) { destination in
                    navigationDestination(for: destination)
                }
                .toolbar{ toolbarContent }
        }
        .preferredColorScheme(profile.theme.colorScheme)
    }
}

// MARK: - Основной контент
private extension StudyView {
    var content: some View {
        VStack(spacing: 20) {
            Spacer()
                
            NavigationLink(value: StudyDestination.tasks) {
                PrimaryButton(title: "Решать задачи")
            }
        }
        .padding()
    }
}

// MARK: - Статистика и кнопки
struct statView: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .imageScale(.small)
                .foregroundColor(Color("AppRed"))
            Text(value)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundColor(.primary)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(.bar, in: Capsule())
    }
}

struct PrimaryButton: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(.title2))
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("AppRed"))
            .foregroundColor(.white)
            .cornerRadius(12)
    }
}


// MARK: - SubViews
private extension StudyView {
    
    //MARK: - ToolBarContent
    var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                showPopover.toggle()
            } label: {
                statView(icon: "star.fill", value: "\(profile.profile.points)")
            }
            .popover(isPresented: $showPopover, attachmentAnchor: .point(.bottom), arrowEdge: .bottom, content: {
                Text("С помощью очков опыта вы можете повысить свой рейтинг и открыть уникальные фишки.")
                    .padding()
                    .foregroundStyle(Color("AppRed"))
                    .frame(maxWidth: 250, minHeight: 90)
                    .presentationCompactAdaptation(.popover)
            })
        }
    }
    
}


// MARK: - Navigation Destinations
private extension StudyView {
    @ViewBuilder
    func navigationDestination(for destination: StudyDestination) -> some View {
        switch destination {
        case .levelTest:
            LevelTestView(profile: profile, navigationPath: $navigationPath)
        case .tasks:
            TasksView(profile: profile, navigationPath: $navigationPath, selectedTab: $selectedTab)
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
