import SwiftUI

// MARK: - Ячейка рейтинга
struct RatingRowView: View {
    let rank: Int
    let user: UserProfile
    var currentUser: UserProfile // добавляем текущий профиль
    
    // MARK: - Цвет бейджа в зависимости от места
    private var rankColor: Color {
        switch rank {
        case 1: return Color(red: 255/255, green: 215/255, blue: 0/255) //gold
        case 2: return Color(red: 196/255, green: 196/255, blue: 196/255) //iron
        case 3: return Color(red: 206/255, green: 137/255, blue: 70/255) //bronze
        default: return .clear
        }
    }
    
    
    
    var body: some View {
        HStack {
            Text("\(rank)")
                .font(.system(.title3, design: .monospaced))
                .foregroundColor(rank <= 3 ? .white : .gray) // текст на цветном фоне
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(rankColor)
                )
                .padding(.horizontal, 10)


            Image(systemName: user.avatar)
                .font(.system(size: 39))
                .foregroundColor(Color("AppRed"))

            VStack(alignment: .leading) {
                Text(user.fullName)
                    .font(.system(.title3))
                Text(user.username)
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "crown.fill")
                    .foregroundColor(Color("AppRed"))
                Text("\(user.raitingPoints)")
            }
            .font(.system(.headline, design: .monospaced))
            .padding(.trailing, 15)
        }
        .frame(maxWidth: 340, maxHeight: 50)
        .padding(.vertical, 10)
    }
}

// MARK: - Preview
struct RatingRow_Previews: PreviewProvider {
    static var previews: some View {
        RatingRowView(rank: 1, user: UserProfile(), currentUser: UserProfile())
    }
}
