import SwiftUI

// MARK: - RatingView
struct RatingView: View {
    @ObservedObject var profile: UserProfileViewModel
    @State var onlyFriend: Bool = false
    @State private var pickerMode: Int = 0

    // В реальном приложении этот список можно будет подтягивать из сервера или локальной базы
    @State private var users: [UserProfile] = [
        UserProfile(firstName: "Павел", lastName: "Дуров", username: "@monk", avatar: "person.circle", level: "advancrd", points: 120041, streak: 5, friendsCount: 10, completedTasks: [], achievements: []),
        UserProfile(firstName: "Илон", lastName: "Маск", username: "@elonmusk", avatar: "star.circle", level: "intermediate", points: 22709, streak: 3, friendsCount: 8, completedTasks: [], achievements: []),
        UserProfile(firstName: "Иван", lastName: "Сидоров", username: "@ivan", avatar: "heart.circle", level: "beginner", points: 910, streak: 7, friendsCount: 12, completedTasks: [], achievements: [])
    ]
    
    @State private var friends: [UserProfile] = []

    // MARK: - Body
    var body: some View {
        NavigationStack {
            content
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Picker("HzChe", selection: $pickerMode) {
                            Text("Общий").tag(0)
                            Text("Друзья").tag(1)
                        }
                        .padding()
                        .pickerStyle(.segmented)
                    }
                }
                .animation(.spring(Spring(mass: 0.001, stiffness: 0.886, damping: 1)), value: pickerMode)
                .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Computed Properties
    private var sortedUsers: [UserProfile] {
        ([profile.profile] + users).sorted { $0.points > $1.points }
    }
    
    private var sortedFriends: [UserProfile] {
        ([profile.profile] + friends).sorted { $0.points > $1.points }
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

// MARK: - Content Body
private extension RatingView {
    var content: some View {
        VStack {
            Text(pickerMode == 0 ? "По количеству очков" : "Среди друзей")
                .font(.subheadline)
                .padding()
            
            ScrollView {
                VStack(spacing: 12) {
                    // Выбираем список в зависимости от вкладки
                    let displayedUsers = pickerMode == 0 ? sortedUsers : sortedFriends
                    
                    ForEach(displayedUsers.indices, id: \.self) { index in
                        RatingRowView(rank: index + 1, user: displayedUsers[index])
                    }
                }
//                .background(RoundedRectangle(cornerRadius: 15).stroke(Color("AppRed"), lineWidth: 1))
                .padding()
            }
        }
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
                    .font(.system(.title3))
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
    }
}

// MARK: - Preview
struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(profile: UserProfileViewModel())
    }
}
