import SwiftUI
import Foundation

enum NavigationDestination: String, Hashable {
    case levelTest
    case tasks
}

struct ContentView: View {
    @StateObject private var userProfile = UserProfileViewModel()
    @State private var selectedTab: Int = 0
    @State private var navigationPath = NavigationPath()

    var body: some View {
        TabView(selection: $selectedTab) {
            // Вкладка "Учеба"
            NavigationStack(path: $navigationPath) {
                VStack(spacing: 20) {
                    Text("Учеба")
                        .font(.system(.largeTitle))
                        .fontWeight(.bold)
                        .foregroundColor(Color("AppRed"))
                        .padding()
                    
                    Spacer()

                    NavigationLink(value: NavigationDestination.levelTest) {
                        Text("Пройти тест уровня")
                            .font(.system(.title2))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("AppRed"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    NavigationLink(value: NavigationDestination.tasks) {
                        Text("Решать задачи")
                            .font(.system(.title2))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("AppRed"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Spacer()
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .levelTest:
                        LevelTestView(profile: userProfile, navigationPath: $navigationPath)
                    case .tasks:
                        TasksView(profile: userProfile, navigationPath: $navigationPath)
                    }
                }
            }
            .tabItem {
                Label("Учеба", systemImage: "book.fill")
            }
            .tag(0)

            // Вкладка "Рейтинг"
            VStack {
                Text("Рейтинг")
                    .font(.system(.largeTitle))
                    .fontWeight(.bold)
                    .foregroundColor(Color("AppRed"))
                    .padding()
                Text("Рейтинг пока в разработке")
                    .font(.system(.title2))
                    .foregroundColor(.gray)
                Spacer()
            }
            .tabItem {
                Label("Рейтинг", systemImage: "chart.bar.fill")
            }.tag(1)

            // Вкладка "Достижения"
            AchievementsView(profile: userProfile)
                .tabItem {
                    Label("Достижения", systemImage: "trophy.fill")
                }.tag(2)

            // Вкладка "Профиль"
            ProfileView(profile: userProfile)
                .tabItem {
                    Label("Профиль", systemImage: "person.fill")
                }.tag(3)
        }
        .accentColor(Color("AppRed"))
        .preferredColorScheme(userProfile.theme.colorScheme)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
