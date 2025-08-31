import SwiftUI

// MARK: - AchievementSquare
struct AchievementSquare: View {
    let achievement: Achievement
    let isUnlocked: Bool
    let size: CGFloat

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: isUnlocked ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 34))
                .foregroundColor(Color("AppRed"))

            Text(achievement.name)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
        }
        .frame(width: size, height: size) // фиксированный квадрат
        .background(
            RoundedRectangle(cornerRadius: 20).fill(Color("TaskBackground"))
        )
        .opacity(isUnlocked ? 1 : 0.5)
    }
}

// MARK: - Preview
struct AchievementSquare_Previews: PreviewProvider {
    static var previews: some View {
        AchievementSquare(
            achievement: Achievement(
                id: UUID(),
                name: "Первое задание",
                description: "Выполни своё первое задание"
            ),
            isUnlocked: true,
            size: 0
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
