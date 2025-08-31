import SwiftUI

// MARK: - AchievementSquare
struct AchievementSquare: View {
    @Environment(\.dismiss) var dismiss
    let achievement: Achievement
    let isUnlocked: Bool
    let size: CGFloat
    
    @State private var showingAchievementDetail: Bool = false

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
        .onTapGesture {
            showingAchievementDetail.toggle()
        }
        .sheet(isPresented: $showingAchievementDetail, content: {
            NavigationStack {
                VStack(spacing: 10) {
                    Image(systemName: isUnlocked ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 70))
                        .foregroundColor(Color("AppRed"))
                    Text(achievement.name)
                        .font(.title)
                    Text(achievement.description)
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { showingAchievementDetail.toggle() }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(.secondary)
                        })
                        .buttonStyle(.plain)
                    }
                }
            }
            .opacity(isUnlocked ? 1: 0.5)
            .presentationDetents([.height(500)])
        })
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
