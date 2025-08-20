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
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(profile.profile.fullName)
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                                .foregroundColor(Color("AppRed"))
                            Text(profile.profile.username)
                                .font(.system(.subheadline, design: .rounded))
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
                .buttonStyle(PlainButtonStyle())
                
                // Секции профиля
                Section {
                    ForEach(ProfileNavigation.section1) { item in
                        sectionView(icon: item.imageName, size: item.imageSize, title: item.title)
                    }
                }
                
                Section {
                    ForEach(ProfileNavigation.section2) { item in
                        sectionView(icon: item.imageName, size: item.imageSize, title: item.title)
                    }
                }
                
                Section {
                    ForEach(ProfileNavigation.section3) { item in
                        sectionView(icon: item.imageName, size: item.imageSize, title: item.title)
                    }
                }
            }
            .navigationTitle("Novator")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingEditView) {
                ProfileEditView(profile: profile)
            }
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
                .foregroundColor(.primary)
        }
    }
    
    @ViewBuilder
    private func sectionView(icon: String, size: CGFloat, title: String) -> some View {
        NavigationLink(destination: Text("\(title) View")) {
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
