import SwiftUI

// MARK: - AchievementSquare
struct AchievementSquare: View {
    let achievement: Achievement
    let isUnlocked: Bool
    let size: CGFloat

    @State private var showingDetail = false

    var body: some View {
        VStack {
            Image(systemName: achievement.icon)
                .font(.system(size: 40))
                .foregroundColor(Color("AppRed"))
        }
        .frame(width: size, height: size)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("SectionBackground"))
        )
        .opacity(isUnlocked ? 1 : 0.5)
        .onTapGesture { showingDetail.toggle() }
        .sheet(isPresented: $showingDetail) {
            AchievementDetailView(
                achievement: achievement,
                isUnlocked: isUnlocked,
                onDismiss: { showingDetail.toggle() }
            )
        }
    }
}

// MARK: - AchievementDetailView
private struct AchievementDetailView: View {
    let achievement: Achievement
    let isUnlocked: Bool
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: achievement.icon)
                    .font(.system(size: 150))
                    .foregroundColor(Color("AppRed"))
                Text(achievement.name)
                    .font(.title)
                Text(achievement.description)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                Spacer()
                Button(action: onDismiss) {
                    Text("ОК")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .frame(minWidth: 300, minHeight: 55)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .opacity(isUnlocked ? 1 : 0.5)
        .presentationDetents([.height(500)])
        .presentationCornerRadius(20)
    }
}
