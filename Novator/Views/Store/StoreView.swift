import SwiftUI

struct StoreView: View {
    
    @ObservedObject var profile: UserProfileViewModel
    
    var body: some View {
        NavigationStack {
            Text("Магазин View")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                StatView(icon: "star.fill", value: "\(profile.profile.stars)")
            }
        }
    }
}
