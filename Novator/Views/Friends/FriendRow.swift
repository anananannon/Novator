import SwiftUI

struct FriendRow: View {
    let user: UserProfile

    var body: some View {
        HStack {
            if let avatarData = user.avatar, let uiImage = UIImage(data: avatarData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                    .padding(.leading, 10)
            } else {
                Image(systemName: "person.circle")
                    .font(.system(size: 35))
                    .foregroundColor(Color("AppRed"))
                    .padding(.leading, 10)
            }
            VStack(alignment: .leading) {
                Text(user.fullName)
                    .font(.system(size: 15))
                Text("Уровень \(user.completedLessons.count)")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                Divider()
            }
        }
    }
}

#Preview {
    FriendRow(user: UserProfile(
        firstName: "Павел",
        lastName: "Дуров",
        username: "@monk",
        avatar: nil,
        stars: 2131212,
        raitingPoints: 120041,
        streak: 5,
        friendsCount: 10,
        friends: [],
        pendingFriendRequests: [],
        completedTasks: [],
        achievements: ["Test", "Test2", "Test3"],
        completedLessons: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"]
    ))
}
