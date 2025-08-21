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
                                .font(.system(size: 21, weight: .medium, design: .rounded))
                                .foregroundColor(Color("AppRed"))
                            Text(profile.profile.username)
                                .font(.system(size: 13, design: .rounded))
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
                        sectionView(icon: item.imageName, size: item.imageSize, title: item.title, link: item.link, profile: profile)
                    }
                }
                
                Section {
                    ForEach(ProfileNavigation.section2) { item in
                        sectionView(icon: item.imageName, size: item.imageSize, title: item.title, link: item.link, profile: profile)
                    }
                }
                
                Section {
                    ForEach(ProfileNavigation.section3) { item in
                        sectionView(icon: item.imageName, size: item.imageSize, title: item.title, link: item.link, profile: profile)
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
    private func sectionView(icon: String, size: CGFloat, title: String, link: AnyView?, profile: UserProfileViewModel) -> some View {
        NavigationLink(destination: link ?? AnyView(Text("\(title) View"))) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: size))
                    .foregroundColor(Color("AppRed"))
                    .frame(width: 28, alignment: .leading)
                Text(title)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(.primary)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profile: UserProfileViewModel())
    }
}
