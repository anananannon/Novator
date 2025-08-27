import SwiftUI

// MARK: - Навигационные точки для Study
enum StudyDestination: String, Hashable {
    case levelTest
    case tasks
}

// MARK: - StudyView
struct StudyView: View {
    @ObservedObject var profile: UserProfileViewModel
    @Binding var navigationPath: NavigationPath
    @Binding var selectedTab: Int
    
    @State private var showPopup = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                content
                
                if showPopup {
                    PopupOverlay {
//                        withAnimation {
                            showPopup = false
//                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        withAnimation {
                            showPopup.toggle()
                        }
                    }) {
                        statView(icon: "star.fill", value: "\(profile.profile.points)")
                    }
                }
            }
            .navigationDestination(for: StudyDestination.self) { destination in
                navigationDestination(for: destination)
            }
        }
    }
}

// MARK: - Основной контент
private extension StudyView {
    var content: some View {
        VStack(spacing: 20) {
            Spacer()
            
            NavigationLink(value: StudyDestination.tasks) {
                PrimaryButton(title: "Решать задачи")
            }
        }
        .padding()
    }
}

// MARK: - Popup Overlay
struct PopupOverlay: View {
    var onDismiss: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }
            
            PopupContent {
                onDismiss()
            }
            .frame(maxWidth: 290)
            .background(.thinMaterial)
            .cornerRadius(20)
            .shadow(radius: 5)
            

            .zIndex(1)
        }
    }
}

// MARK: - Содержимое Popup
struct PopupContent: View {
    var onClose: () -> Void
    
    var body: some View {
        VStack() {
            Image(systemName: "star.fill")
                .font(.system(size: 45))
                .foregroundStyle(Color("AppRed"))
                .padding(.all, 9)
            
            Text("Очки опыта показывают, на каком уровне владения вы сейчас находитесь, с помощью них вы можете повысить свой рейтинг, а так же можете разблокировать уникальные фишки! Подробнее вы можете узнать во вкладке 'unical features'")
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
        }
        .padding()
    }
}

// MARK: - Статистика и кнопки
struct statView: View {
    let icon: String
    let value: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .imageScale(.small)
                .foregroundColor(Color("AppRed"))
            Text(value)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundColor(.primary)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 10)
        .background(.thinMaterial, in: Capsule())
    }
}

struct PrimaryButton: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(.title2))
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("AppRed"))
            .foregroundColor(.white)
            .cornerRadius(12)
    }
}

// MARK: - Navigation Destinations
private extension StudyView {
    @ViewBuilder
    func navigationDestination(for destination: StudyDestination) -> some View {
        switch destination {
        case .levelTest:
            LevelTestView(profile: profile, navigationPath: $navigationPath)
        case .tasks:
            TasksView(profile: profile, navigationPath: $navigationPath, selectedTab: $selectedTab)
        }
    }
}

// MARK: - Preview
struct StudyView_Previews: PreviewProvider {
    static var previews: some View {
        StudyView(
            profile: UserProfileViewModel(),
            navigationPath: .constant(NavigationPath()),
            selectedTab: .constant(0)
        )
    }
}
