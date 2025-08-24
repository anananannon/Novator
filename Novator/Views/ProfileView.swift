import SwiftUI
import Foundation

struct ProfileView: View {
    @ObservedObject var profile: UserProfileViewModel
    @State private var showingEditView = false

    var body: some View {
        NavigationStack {
            List {
                // Кнопка профиля
                Button(action: { showingEditView = true }) {
                    HStack {
                        Image(systemName: profile.profile.avatar)
                            .font(.system(size: 50))
                            .foregroundColor(Color("AppRed"))
                            .padding(.leading, 2)
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(profile.profile.fullName)
                                .font(.system(size: 21, weight: .medium))
                                .foregroundColor(Color("AppRed"))
                            Text(profile.profile.username)
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            statView(icon: "flame.fill", value: "\(profile.profile.streak)")
                            statView(icon: "star.fill", value: "\(profile.profile.points)")
                            statView(icon: "person.2.fill", value: "\(profile.profile.friendsCount)")
                        }
                    }
                    .padding(.vertical, 8)
                }

                // Секции профиля
                Section {
                    ForEach(ProfileNavigation.section1) { item in
                        sectionView(icon: item.imageName, size: item.imageSize, title: item.title, destinationType: item.destinationType, profile: profile)
                    }
                }
                
                Section {
                    ForEach(ProfileNavigation.section2) { item in
                        sectionView(icon: item.imageName, size: item.imageSize, title: item.title, destinationType: item.destinationType, profile: profile)
                    }
                }
                
                Section {
                    ForEach(ProfileNavigation.section3) { item in
                        sectionView(icon: item.imageName, size: item.imageSize, title: item.title, destinationType: item.destinationType, profile: profile)
                    }
                }
            }
            .navigationTitle("Novator")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingEditView) {
                ProfileEditView(profile: profile)
            }
            .preferredColorScheme(profile.theme.colorScheme)
        }
    }
    
    @ViewBuilder
    private func statView(icon: String, value: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Color("AppRed"))
                .frame(width: 20, alignment: .leading)
            Text(value)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
    
    @ViewBuilder
    private func sectionView(icon: String, size: CGFloat, title: String, destinationType: ProfileNavigationItem.DestinationType, profile: UserProfileViewModel) -> some View {
        NavigationLink(destination: destinationView(for: destinationType, profile: profile)) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: size))
                    .foregroundColor(Color("AppRed"))
                    .frame(width: 28, alignment: .leading)
                Text(title)
                    .font(.system(.body))
                    .foregroundColor(.primary)
            }
        }
    }
    
    @ViewBuilder
    private func destinationView(for destinationType: ProfileNavigationItem.DestinationType, profile: UserProfileViewModel) -> some View {
        switch destinationType {
        case .settings:
            SettingsView(profile: profile)
        case .statistics, .activity, .friends, .chats, .privacy, .connectedDevices, .downloadedFiles:
            Text("\(destinationType.title) View")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profile: UserProfileViewModel())
    }
}

extension ProfileNavigationItem.DestinationType {
    var title: String {
        switch self {
        case .settings:
            return "Настройки"
        case .statistics:
            return "Статистика"
        case .activity:
            return "Активность"
        case .friends:
            return "Друзья"
        case .chats:
            return "Чаты"
        case .privacy:
            return "Конфиденциальность"
        case .connectedDevices:
            return "Подключенные устройства"
        case .downloadedFiles:
            return "Скачанные файлы"
        }
    }
}
