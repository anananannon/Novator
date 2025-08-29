import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @StateObject private var userProfile = UserProfileViewModel()
    @State private var selectedTab: Int = 0
//    @State private var navigationPath = NavigationPath()

    // MARK: - Body
    var body: some View {
        TabView(selection: $selectedTab) {
            // Учеба
            StudyView(profile: userProfile, selectedTab: $selectedTab)
                .tabItem {
                    Label("Учеба", systemImage: "book.fill")
                }
                .tag(0)

            // Рейтинг
            RatingView(profile: userProfile)
                .tabItem {
                    Label("Рейтинг", systemImage: "chart.bar.fill")
                }
                .tag(1)

            // Достижения
            AchievementsView(profile: userProfile)
                .tabItem {
                    Label("Достижения", systemImage: "trophy.fill")
                }
                .tag(2)

            // Профиль
            ProfileView(profile: userProfile)
                .tabItem {
                    Label("Профиль", systemImage: "person.fill")
                }
                .tag(3)
        }
        .accentColor(Color("AppRed"))
        .preferredColorScheme(userProfile.theme.colorScheme)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
