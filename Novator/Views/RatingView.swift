import SwiftUI

struct RatingView: View {
    @ObservedObject var profile: UserProfileViewModel
    
    var body: some View {
        VStack {
            Text("Рейтинг")
                .font(.system(.largeTitle))
                .fontWeight(.bold)
                .foregroundColor(Color("AppRed"))
                .padding()
            Text("Рейтинг пока в разработке")
                .font(.system(.title2))
                .foregroundColor(.gray)
            Spacer()
        }
    }
}

#Preview {
    RatingView(profile: UserProfileViewModel())
}
