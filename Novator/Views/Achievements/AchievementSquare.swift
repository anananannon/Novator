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
            Image(systemName: achievement.icon) // Поменять на achievement.icoon
                .font(.system(size: 40))
                .foregroundColor(Color("AppRed"))
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
                    
                    Button {
                        showingAchievementDetail.toggle()
                    } label: {
                        Text("ОК")
                            .frame(minWidth: 300, minHeight: 55)
                    }
                    .buttonStyle(PrimaryButtonStyle())
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
            .presentationCornerRadius(20)
        })
    }
}

// MARK: - Preview
struct AchievementSquare_Previews: PreviewProvider {
    static var previews: some View {
        AchievementSquare(
            achievement: Achievement(
                id: UUID(),
                icon: "",
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
