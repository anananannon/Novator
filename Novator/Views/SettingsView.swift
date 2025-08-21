import SwiftUI

// MARK: - SettingsView
struct SettingsView: View {
    @ObservedObject var profile: UserProfileViewModel
    @Environment(\.dismiss) var dismiss

    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Общие").font(.subheadlineRounded)) {
                    Menu {
                        ForEach(UserProfileViewModel.Theme.allCases, id: \.self) { theme in
                            Button {
                                profile.theme = theme
                            } label: {
                                HStack {
                                    Text(theme == .light ? "Светлая" : theme == .dark ? "Тёмная" : "Системная")
                                        .font(.bodyRounded)
                                    if profile.theme == theme {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color("AppRed"))
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text("Тема приложения")
                                .font(.bodyRounded)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(profile.theme == .light ? "Светлая" : profile.theme == .dark ? "Тёмная" : "Системная")
                                .font(.bodyRounded)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(profile.theme.colorScheme)
    }
}

// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(profile: UserProfileViewModel())
    }
}
