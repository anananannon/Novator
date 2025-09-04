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
                Image(systemName: "lane")
                    .imageScale(.large)
                    .bold()
                    .foregroundStyle(rankColor)
                
                Text("\(rank)")
                    .font(.system(.title3, design: .monospaced))
                    .foregroundColor(rank <= 3 ? rankColor : .gray) // текст на цветном фоне
            }
            .padding(.horizontal, 12)
                

            // Обработка аватара
            if let avatarData = user.avatar, let uiImage = UIImage(data: avatarData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
                    .foregroundColor(Color("AppRed"))
            }

            VStack(alignment: .leading) {
                Text(user.fullName)
                    .font(.system(size: 17))
                Text(user.username)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            Spacer()

            HStack(spacing: 4) {
                Text("\(user.raitingPoints)")
                Image(systemName: "crown.fill")
                    .foregroundColor(Color("AppRed"))
            }
            .font(.system(.headline, design: .monospaced))
            .padding(.trailing, 5)
            
            Image(systemName: "chevron.right")
                .imageScale(.medium)
                .bold()
                .foregroundStyle(.secondary)
                .padding(.trailing, 9)
        }
        .frame(maxWidth: .infinity, maxHeight: 50)
        .padding(.vertical, 6)
        .background(user.id == currentUser.id ? Color(.black).opacity(0.1) : .clear)
    }
}

// MARK: - Preview
struct RatingRow_Previews: PreviewProvider {
    static var previews: some View {
        RatingRowView(rank: 1, user: UserProfile(), currentUser: UserProfile())
    }
}
