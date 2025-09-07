import SwiftUI

// MARK: - Ячейка рейтинга
struct RatingRowView: View {
    let rank: Int
    let user: UserProfile
    let currentUser: UserProfile

    // MARK: - Цвет бейджа
    private var rankColor: Color {
        switch rank {
        case 1: return Color.yellow
        case 2: return Color.gray
        case 3: return Color.brown
        default: return .clear
        }
    }

    var body: some View {
        HStack {
            ZStack {
                Image(systemName: "circle.fill")
                    .imageScale(.large)
                    .bold()
                    .foregroundColor(rankColor)
                    .overlay(
                        Text("\(rank)")
                            .font(.system(.subheadline))
                            .foregroundColor(rank <= 3 ? .primary : .gray)
                    )
            }
            .padding(.leading, 9)
            .padding(.trailing, 5)

            if let avatarData = user.avatar, let uiImage = UIImage(data: avatarData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36, height: 36)
                    .foregroundColor(Color("AppRed"))
            }

            VStack(alignment: .leading) {
                Text(user.fullName)
                    .font(.system(size: 15))
                Text(user.username)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.leading, 4)
            Spacer()

            HStack(spacing: 4) {
                Text("\(user.raitingPoints)")
                Image(systemName: "crown.fill")
                    .foregroundColor(Color("AppRed"))
            }
            .font(.system(size: 13, weight: .medium))
            .padding(.trailing, 5)

            Image(systemName: "chevron.right")
                .imageScale(.small)
                .bold()
                .foregroundStyle(.secondary)
                .padding(.trailing, 9)
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .padding(.vertical, 6)
        .background(user.id == currentUser.id ? Color.black.opacity(0.1) : Color.black.opacity(0.00000001))
    }
}

// MARK: - Preview
struct RatingRow_Previews: PreviewProvider {
    static var previews: some View {
        RatingRowView(rank: 1, user: UserProfile(firstName: "Иван", lastName: "Иванов", username: "@ivan", avatar: nil, stars: 0, raitingPoints: 10, streak: 0, friendsCount: 0, completedTasks: [], achievements: []), currentUser: UserProfile(firstName: "Иван", lastName: "Иванов", username: "@ivan", avatar: nil, stars: 0, raitingPoints: 10, streak: 0, friendsCount: 0, completedTasks: [], achievements: []))
    }
}
