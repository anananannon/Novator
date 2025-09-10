import SwiftUI

struct StoreView: View {
    
    @ObservedObject var profile: UserProfileViewModel
    @State private var showPopover = false
    
    var body: some View {
        NavigationStack {
            Text("Магазин View")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                
                Button {
                    showPopover.toggle()
                } label: {
                    StatView(icon: "star.fill", value: "\(profile.profile.stars)")
                }
                .popover(isPresented: $showPopover) {
                    Text("Очки опыта - вы можете потратить их в магазине украшений профиля.")
                        .padding()
                        .foregroundColor(Color("AppRed"))
                        .frame(maxWidth: 210, minHeight: 90)
                        .presentationCompactAdaptation(.popover)
                }
            }
        }
    }
}
