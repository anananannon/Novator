import SwiftUI

// MARK: - RatingView
struct RatingView: View {
    @ObservedObject var profile: UserProfileViewModel

    // В реальном приложении этот список можно будет подтягивать из сервера или локальной базы
    @State private var users: [UserProfile] = [
        UserProfile(firstName: "Павел", lastName: "Дуров", username: "@monk", avatar: "person.circle", level: "advancrd", points: 120041, streak: 5, friendsCount: 10, completedTasks: [], achievements: []),
        UserProfile(firstName: "Илон", lastName: "Маск", username: "@elonmusk", avatar: "star.circle", level: "intermediate", points: 22709, streak: 3, friendsCount: 8, completedTasks: [], achievements: []),
        UserProfile(firstName: "Иван", lastName: "Сидоров", username: "@ivan", avatar: "heart.circle", level: "beginner", points: 910, streak: 7, friendsCount: 12, completedTasks: [], achievements: [])
    ]

    // MARK: - Body
    var body: some View {
        VStack {
            ratingHeader
            Text("По количеству очков")
                .font(.subheadline)
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(sortedUsers.indices, id: \.self) { index in
                        RatingRowView(rank: index + 1, user: sortedUsers[index])
                    }
                }
                .background(RoundedRectangle(cornerRadius: 15).stroke(Color("AppRed"), lineWidth: 1))
                .padding()
            }
        }
    }

    // MARK: - Computed Properties
    private var sortedUsers: [UserProfile] {
        ([profile.profile] + users).sorted { $0.points > $1.points }
    }

    // MARK: - Header
    private var ratingHeader: some View {
        Text("Рейтинг")
            .font(.system(.largeTitle, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(Color("AppRed"))
            .padding()
    }
}

// MARK: - RatingRowView
struct RatingRowView: View {
    let rank: Int
    let user: UserProfile

    var body: some View {
        HStack {
            Text("#\(rank)")
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.leading, 10)
            
            Divider()
            
            Image(systemName: user.avatar)
                .font(.system(size: 40))
                .foregroundColor(Color("AppRed"))
            
            VStack(alignment: .leading) {
                Text(user.fullName)
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                Text(user.username)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(Color("AppRed"))
                Text("\(user.points)")
            }
            .padding(.trailing, 15)
        }
        .frame(maxWidth: 340, maxHeight: 50)
        .padding(.vertical, 10)
//        .background(RoundedRectangle(cornerRadius: 15).stroke(Color("AppRed"), lineWidth: 1))
    }
}

// MARK: - Preview
struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(profile: UserProfileViewModel())
    }
}
