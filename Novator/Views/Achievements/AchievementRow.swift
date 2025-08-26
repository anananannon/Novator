import SwiftUI

// MARK: - AchievementRow
struct AchievementRow: View {
    let achievement: Achievement
    let isUnlocked: Bool

    // MARK: - Body
    var body: some View {
        HStack {
            icon
            details
            Spacer()
        }
//        .padding(.vertical, 4)
    }
}

// MARK: - Subviews
private extension AchievementRow {
    var icon: some View {
        Image(systemName: isUnlocked ? "checkmark.circle.fill" : "circle")
            .font(.system(size: 24))
            .foregroundColor(Color("AppRed"))
    }

    var details: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(achievement.name)
                .font(.body)
                .foregroundColor(.primary)

            Text(achievement.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview
struct AchievementRow_Previews: PreviewProvider {
    static var previews: some View {
        AchievementRow(
            achievement: Achievement(
                id: UUID(),
                name: "Первое задание",
                description: "Выполни своё первое задание"
            ),
            isUnlocked: true
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
