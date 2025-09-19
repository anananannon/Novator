import SwiftUI

struct PrivacyView: View {
    @EnvironmentObject var profileVM: UserProfileViewModel
    
    // Кастомный Binding для showAchievements
    private var showAchievementsBinding: Binding<Bool> {
        Binding(
            get: { profileVM.profile.privacySettings.showAchievements },
            set: { newValue in
                profileVM.profile.privacySettings.showAchievements = newValue
                profileVM.saveProfile()
                print("🔒 Достижения теперь \(newValue ? "видны" : "скрыты")")
            }
        )
    }
    
    // Новое: Кастомный Binding для showAccessories
    private var showAccessoriesBinding: Binding<Bool> {
        Binding(
            get: { profileVM.profile.privacySettings.showAccessories },
            set: { newValue in
                profileVM.profile.privacySettings.showAccessories = newValue
                profileVM.saveProfile()
                print("🔒 Аксессуары теперь \(newValue ? "видны" : "скрыты")")
            }
        )
    }
    
    // Пример Binding для showFriendsList
    private var showFriendsListBinding: Binding<Bool> {
        Binding(
            get: { profileVM.profile.privacySettings.showFriendsList },
            set: { newValue in
                profileVM.profile.privacySettings.showFriendsList = newValue
                profileVM.saveProfile()
                print("🔒 Список друзей теперь \(newValue ? "виден" : "скрыт")")
            }
        )
    }
    
    var body: some View {
         List {
             Section(footer: Text("Отключите, если не хотите что бы другие пользователи видели ваши достижения.")) {
                 Toggle("Показывать достижения", isOn: showAchievementsBinding)
                     .toggleStyle(SwitchToggleStyle(tint: Color("AppRed")))
             }
             
             // Новое: Секция для аксессуаров
             Section(footer: Text("Отключите, если не хотите что бы другие пользователи видели ваши аксессуары.")) {
                 Toggle("Показывать аксессуары", isOn: showAccessoriesBinding)
                     .toggleStyle(SwitchToggleStyle(tint: Color("AppRed")))
             }
             
             // Разкомментируйте для друзей, если нужно
             // Section(header: Text("Друзья")) {
             //     Toggle("Показывать список друзей", isOn: showFriendsListBinding)
             //         .toggleStyle(SwitchToggleStyle(tint: Color("AppRed")))
             // }
             
             // Добавляйте новые секции/Toggle по мере расширения
             // Section(header: Text("Статистика")) {
             //     Toggle("Показывать статистику", isOn: showStatisticsBinding)
             // }
        }
        .navigationTitle("Конфиденц.")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PrivacyView()
        .environmentObject(UserProfileViewModel())
}
