import SwiftUI

struct FriendRow: View {
    let friend: UserProfile

    var body: some View {
        HStack {
            if let avatarData = friend.avatar, let uiImage = UIImage(data: avatarData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .foregroundColor(Color("AppRed"))
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Color("AppRed"))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(friend.fullName)
                    .font(.system(.body, weight: .medium))
                    .foregroundColor(.primary)
                Text(friend.username)
                    .font(.system(.subheadline))
                    .foregroundColor(.gray)
            }

            Spacer()

            Text("\(friend.raitingPoints)")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.semibold)
                .foregroundColor(Color("AppRed"))
        }
        .padding(.vertical, 4)
    }
}

struct FriendRow_Previews: PreviewProvider {
    static var previews: some View {
        FriendRow(friend: UserProfile(
            id: UUID(uuidString: "550E8400-E29B-41D4-A716-446655440001")!,
            firstName: "Илон",
            lastName: "Маск",
            username: "@elonmusk",
            avatar: nil,
            stars: 1200,
            raitingPoints: 22709,
            streak: 3,
            friendsCount: 8,
            friends: [],
            pendingFriendRequests: [],
            incomingFriendRequests: [],
            completedTasks: [],
            achievements: [],
            completedLessons: []
        ))
    }
}
