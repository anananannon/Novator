import SwiftUI

struct ContentView: View {
    // MARK: - Properties
    @StateObject private var userProfileVM = UserProfileViewModel()
    @StateObject private var notificationManager = NotificationManager()
    @State private var selectedTab: Int = 0

    // MARK: - Body
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                StudyView(profile: userProfileVM, selectedTab: $selectedTab, notificationManager: notificationManager)
                    .tabItem {
                        Label("Учеба", systemImage: "book.fill")
                    }
                    .tag(0)
                RatingView(profile: userProfileVM)
                    .tabItem {
                        Label("Рейтинг", systemImage: "crown.fill")
                    }
                    .tag(1)
                AchievementsView(profile: userProfileVM)
                    .tabItem {
                        Label("Достижения", systemImage: "trophy.fill")
                    }
                    .tag(2)
                ProfileView()
                    .tabItem {
                        Label("Профиль", systemImage: "person.fill")
                    }
                    .tag(3)
            }
            .accentColor(Color("AppRed"))
            .preferredColorScheme(userProfileVM.theme.colorScheme)
            .environmentObject(userProfileVM)

            // Уведомления
            VStack {
                ForEach(notificationManager.notifications) { notification in
                    NotificationView(notification: notification) {
                        withAnimation(.spring(response: 0.3)) {
                            notificationManager.notifications.removeAll { $0.id == notification.id }
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
                }
                Spacer()
            }
            .animation(.spring(response: 0.3), value: notificationManager.notifications)
        }
    }
}
