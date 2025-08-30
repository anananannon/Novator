import SwiftUI

struct PrimaryButton: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(.title3))
            .frame(maxWidth: 333.63, maxHeight: 47)
            .background(Color("AppRed"))
            .foregroundColor(.white)
            .cornerRadius(16)
    }
}
