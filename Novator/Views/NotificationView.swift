import SwiftUI

struct NotificationView: View {
    let notification: Notification
    let onDismiss: () -> Void
    
    @Environment(\.colorScheme) private var systemColorScheme
    
    var body: some View {
        
        HStack {
            Image(systemName: notification.icon)
                .font(.system(size: 26))
                .padding(.horizontal, 12)
                .foregroundColor(Color("AppRed"))
            VStack {
                HStack {
                    Text("\(notification.title)")
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                    Spacer()
                }
                HStack {
                    Text("\(notification.message)")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(systemColorScheme == .light ? .white : .sectionBackground)
                .shadow(radius: 2)
        )
        .padding(.horizontal, 12)
        .transition(.asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        ))
    }
}


