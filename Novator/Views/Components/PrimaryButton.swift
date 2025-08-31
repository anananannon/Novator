import SwiftUI

//struct PrimaryButton: View {
//    let title: String
//    
//    var body: some View {
//        Text(title)
//            .font(.system(.title3))
//            .frame(maxWidth: 333.63, maxHeight: 47)
//            .background(Color("AppRed"))
//            .foregroundColor(.white)
//            .cornerRadius(16)
//    }
//}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color("AppRed"))
            .foregroundColor(.white)
            .cornerRadius(16)
            .opacity(configuration.isPressed ? 0.8 : 1.0)     // затемняем при нажатии
    }
}
