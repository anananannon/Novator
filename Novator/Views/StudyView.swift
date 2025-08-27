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
                        withAnimation {
                            showPopup = false
                        }
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
            
            Spacer()
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
            .frame(width: 300, height: 200)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
            .shadow(radius: 10)
            .transition(.scale)
            .zIndex(1)
        }
    }
}

// MARK: - Содержимое Popup
struct PopupContent: View {
    var onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Всплывающее окно")
                .font(.title2)
                .bold()
            Text("Здесь можно разместить любую информацию")
                .multilineTextAlignment(.center)
            Button("Закрыть") {
                onClose()
            }
            .padding()
            .background(Color("AppRed"))
            .foregroundColor(.white)
            .cornerRadius(12)
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
