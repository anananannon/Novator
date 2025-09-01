import SwiftUI

// MARK: - AchievementSquare
struct AchievementSquare: View {
    @Environment(\.dismiss) private var dismiss
    let achievement: Achievement
    let isUnlocked: Bool
    let size: CGFloat
    
    @State private var showingAchievementDetail: Bool = false

    // MARK: - Body
    var body: some View {
        VStack(spacing: 8) {
            AchievementIconView(icon: achievement.icon)
        }
        .frame(width: size, height: size)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("TaskBackground"))
        )
        .opacity(isUnlocked ? 1 : 0.5)
        .onTapGesture {
            showingAchievementDetail.toggle()
        }
        .sheet(isPresented: $showingAchievementDetail) {
            AchievementDetailView(
                achievement: achievement,
                isUnlocked: isUnlocked,
                onDismiss: { showingAchievementDetail.toggle() }
            )
        }
    }
}

// MARK: - AchievementIconView
private struct AchievementIconView: View {
    let icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 40))
            .foregroundColor(Color("AppRed"))
    }
}

// MARK: - AchievementDetailView
private struct AchievementDetailView: View {
    let achievement: Achievement
    let isUnlocked: Bool
    let onDismiss: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Spacer()
                
                Image(systemName: achievement.icon)
                    .font(.system(size: 150))
                    .foregroundColor(Color("AppRed"))
                
                Spacer()
                
                Text(achievement.name)
                    .font(.title)
                
                Text(achievement.description)
                    .font(.headline)
                    .foregroundStyle(.secondary)
                
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

// MARK: - Preview
struct AchievementSquare_Previews: PreviewProvider {
    static var previews: some View {
        AchievementSquare(
            achievement: Achievement(
                id: UUID(),
                icon: "star.fill",
                name: "Первое задание",
                description: "Выполни своё первое задание"
            ),
            isUnlocked: true,
            size: 120
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

