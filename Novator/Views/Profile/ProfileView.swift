import SwiftUI
import Foundation

// MARK: - ProfileView
struct ProfileView: View {
    // MARK: - Properties
    @ObservedObject var profile: UserProfileViewModel
    @State private var showingEditView = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Novator")
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showingEditView) {
                    ProfileEditView(profile: profile)
                }
                .preferredColorScheme(profile.theme.colorScheme)
        }
    }
}

// MARK: - Content
private extension ProfileView {
    var content: some View {
        List {
            profileHeader
            section(ProfileNavigation.section1)
            section(ProfileNavigation.section2)
            section(ProfileNavigation.section3)
        }
    }
}

// MARK: - Header
private extension ProfileView {
    var profileHeader: some View {
        Button(action: { showingEditView = true }) {
            HStack {
                if let avatarData = profile.profile.avatar, let uiImage = UIImage(data: avatarData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .foregroundColor(Color("AppRed"))
                        .padding(.leading, 2)
                } else {
                    Image(systemName: "person.circle")
                        .font(.system(size: 60))
                        .foregroundColor(Color("AppRed"))
                        .padding(.leading, 2)
                }
                
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
                    StatChip(icon: "flame.fill", value: "\(profile.profile.streak)")
                    StatChip(icon: "crown.fill", value: "\(profile.profile.raitingPoints)")
                    StatChip(icon: "person.2.fill", value: "\(profile.profile.friendsCount)")
                }
            }
            .padding(.vertical, 8)
        }
    }
}

// MARK: - Sections
private extension ProfileView {
    func section(_ items: [ProfileNavigationItem]) -> some View {
        Section {
            ForEach(items) { item in
                SectionRow(item: item, profile: profile)
            }
        }
    }
}

// MARK: - Components
private struct StatChip: View {
    let icon: String
    let value: String
    
    var body: some View {
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
}

private struct SectionRow: View {
    let item: ProfileNavigationItem
    let profile: UserProfileViewModel
    
    var body: some View {
        NavigationLink(destination: destinationView) {
            HStack(spacing: 12) {
                Image(systemName: item.imageName)
                    .font(.system(size: item.imageSize))
                    .foregroundColor(Color("AppRed"))
                    .frame(width: 28, alignment: .leading)
                Text(item.title)
                    .font(.system(.body))
                    .foregroundColor(.primary)
            }
        }
    }
    
    @ViewBuilder
    private var destinationView: some View {
        switch item.destinationType {
        case .settings:
            SettingsView(profile: profile)
        case .store:
            StoreView(profile: profile)
        default:
            Text("\(item.destinationType.title) View")
        }
    }
}

// MARK: - Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profile: UserProfileViewModel())
    }
}

// MARK: - Extensions
extension ProfileNavigationItem.DestinationType {
    var title: String {
        switch self {
        case .settings: return "Настройки"
        case .statistics: return "Статистика"
        case .store: return "Магазин"
        case .friends: return "Друзья"
        case .chats: return "Чаты"
        case .privacy: return "Конфиденциальность"
        case .connectedDevices: return "Подключенные устройства"
        case .downloadedFiles: return "Скачанные файлы"
        }
    }
}
