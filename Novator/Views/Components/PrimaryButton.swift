import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color("AppRed"))
            .foregroundColor(.white)
            .cornerRadius(16)
            .opacity(configuration.isPressed ? 0.8 : 1.0)     // затемняем при нажатии
    }
}
