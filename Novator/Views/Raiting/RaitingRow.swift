import SwiftUI

// MARK: - Ячейка рейтинга
struct RatingRowView: View {
    let rank: Int
    let user: UserProfile
    var currentUser: UserProfile // текущий профиль
    
    // MARK: - Цвет бейджа в зависимости от места
    private var rankColor: Color {
        switch rank {
        case 1: return Color(red: 255/255, green: 215/255, blue: 0/255) // gold
        case 2: return Color(red: 196/255, green: 196/255, blue: 196/255) // iron
        case 3: return Color(red: 206/255, green: 137/255, blue: 70/255) // bronze
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
                    .overlay {
                        Text("\(rank)")
                            .font(.system(.subheadline))
                            .foregroundColor(.gray) // текст на цветном фоне
                    }
                
                
            }
            .padding(.leading, 9)
            .padding(.trailing, 5)
                

            // Обработка аватара
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
            .font(.system(size:13, weight: .medium))
            .padding(.trailing, 5)
            
            Image(systemName: "chevron.right")
                .imageScale(.small)
                .bold()
                .foregroundStyle(.secondary)
                .padding(.trailing, 9)
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .padding(.vertical, 6)
        .background(user.id == currentUser.id ? Color(.black).opacity(0.1) : Color(.black).opacity(0.00001))
    }
}

// MARK: - Preview
struct RatingRow_Previews: PreviewProvider {
    static var previews: some View {
        RatingRowView(rank: 1, user: UserProfile(), currentUser: UserProfile())
    }
}
