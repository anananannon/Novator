import SwiftUI

// MARK: - SettingsView
struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel

    init(profile: UserProfileViewModel) {
        self._viewModel = StateObject(wrappedValue: SettingsViewModel(profile: profile))
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Общие").font(.subheadlineRounded)) {
                    Menu {
                        ForEach(UserProfileViewModel.Theme.allCases, id: \.self) { theme in
                            Button {
                                viewModel.updateTheme(theme)
                            } label: {
                                HStack {
                                    Image(systemName: theme == .light ? "sun.max.fill" : theme == .dark ? "moon.fill" : "gearshape.fill")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color("AppRed"))
                                    Text(theme == .light ? "Светлая" : theme == .dark ? "Тёмная" : "Системная")
                                        .font(.bodyRounded)
                                    if viewModel.selectedTheme == theme {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(Color("AppRed"))
                                    }
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Image(systemName: "paintpalette.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Color("AppRed"))
                            Text("Тема приложения")
                                .font(.bodyRounded)
                                .foregroundColor(.primary)
                            Spacer()
                            Text(viewModel.selectedTheme == .light ? "Светлая" : viewModel.selectedTheme == .dark ? "Тёмная" : "Системная")
                                .font(.bodyRounded)
                                .foregroundColor(.gray)
                        }
                    }

                    Toggle(isOn: $viewModel.notificationsEnabled) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Color("AppRed"))
                            Text("Уведомления")
                                .font(.bodyRounded)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(viewModel.selectedTheme.colorScheme)
    }
}

// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(profile: UserProfileViewModel())
    }
}
