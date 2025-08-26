import SwiftUI

// MARK: - Навигационные точки для Study
enum StudyDestination: String, Hashable {
    case levelTest
    case tasks
}

// MARK: - StudyView
struct StudyView: View {
    @ObservedObject var profile: UserProfileViewModel
    @Binding var navigationPath: NavigationPath
    @Binding var selectedTab: Int

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $navigationPath) {
            content
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: StudyDestination.self, destination: navigationDestination)
        }
    }
}

// MARK: - Content
private extension StudyView {
    var content: some View {
        VStack(spacing: 20) {
            header

            Spacer()

            NavigationLink(value: StudyDestination.levelTest) {
                primaryButton(title: "Пройти тест уровня")
            }

            NavigationLink(value: StudyDestination.tasks) {
                primaryButton(title: "Решать задачи")
            }

            Spacer()
        }
        .padding()
    }
}

// MARK: - Subviews
private extension StudyView {
    var header: some View {
        Text("Учеба")
            .font(.system(.largeTitle))
            .fontWeight(.bold)
            .foregroundColor(Color("AppRed"))
            .padding()
    }

    func primaryButton(title: String) -> some View {
        Text(title)
            .font(.system(.title2))
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("AppRed"))
            .foregroundColor(.white)
            .cornerRadius(12)
    }

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
        StudyView(profile: UserProfileViewModel(), navigationPath: .constant(NavigationPath()), selectedTab: .constant(0))
    }
}
