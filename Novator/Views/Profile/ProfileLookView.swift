import SwiftUI

struct ProfileLookView: View {
    let user: UserProfile
    
    var body: some View {
        VStack {
//            Text("Профиль пользователя: \(user.fullName)")
//                .font(.title)
//            Text("Username: \(user.username)")
//                .font(.headline)
//                .foregroundColor(.gray)
//            Text("Рейтинг: \(user.raitingPoints)")
//                .font(.subheadline)
//            Spacer()
            Text("Это заглушка для ProfileLookView")
                .foregroundColor(.red)
//            Spacer()
        }
    }
}

// MARK: - Preview
struct ProfileLookView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileLookView(user: UserProfile(
            firstName: "Павел",
            lastName: "Дуров",
            username: "@monk",
            avatar: nil,
            stars: 2131212,
            raitingPoints: 120041,
            streak: 5,
            friendsCount: 10,
            completedTasks: [],
            achievements: []
        ))
    }
}
