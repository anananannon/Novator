import SwiftUI

struct NotificationView: View {
    let notification: Notification
    let onDismiss: () -> Void

    var body: some View {
        HStack {
            Image(systemName: notification.icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding(.leading, 10)

            VStack(alignment: .leading, spacing: 4) {
                Text(notification.title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                Text(notification.message)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.9))
                    .lineLimit(2)
            }
            Spacer()
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                    .padding(8)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.8))
                .shadow(radius: 5)
        )
        .padding(.horizontal, 16)
        .transition(.asymmetric(
            insertion: .move(edge: .top).combined(with: .opacity),
            removal: .move(edge: .top).combined(with: .opacity)
        ))
    }
}
