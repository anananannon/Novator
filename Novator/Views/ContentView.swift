import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @StateObject private var userProfileVM = UserProfileViewModel()
    @State private var selectedTab: Int = 0

    // MARK: - Body
    var body: some View {
        TabView(selection: $selectedTab) {
            // Учеба
            StudyView(profile: userProfileVM, selectedTab: $selectedTab)
                .tabItem {
                    Label("Учеба", systemImage: "book.fill")
                }
                .tag(0)

            // Рейтинг
            RatingView(profile: userProfileVM)
                .tabItem {
                    Label("Рейтинг", systemImage: "crown.fill")
                }
                .tag(1)

            // Достижения
            AchievementsView(profile: userProfileVM)
                .tabItem {
                    Label("Достижения", systemImage: "trophy.fill")
                }
                .tag(2)

            // Профиль
            ProfileView(profile: userProfileVM)
                .tabItem {
                    Label("Профиль", systemImage: "person.fill")
                }
                .tag(3)
        }
        .accentColor(Color("AppRed"))
        .preferredColorScheme(userProfileVM.theme.colorScheme)
        .environmentObject(userProfileVM) // Добавляем EnvironmentObject
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
