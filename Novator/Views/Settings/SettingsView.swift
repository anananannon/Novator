import SwiftUI

// MARK: - SettingsView
struct SettingsView: View {
    @StateObject private var viewModel: SettingsViewModel

    init(profile: UserProfileViewModel) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(profile: profile))
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                generalSection
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Настройки")
            .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(viewModel.selectedTheme.colorScheme)
    }

    // MARK: - Общие настройки
    private var generalSection: some View {
        Section(header: Text("Общие").font(.subheadline)) {
            themePicker
            notificationsToggle
        }
    }

    // MARK: - Выбор темы
    private var themePicker: some View {
        HStack {
            Image(systemName: "paintpalette.fill")
                .font(.system(size: 16))
                .foregroundColor(Color("AppRed"))
            Text("Тема приложения")
                .font(.body)
                .foregroundColor(.primary)
            Spacer()
            
            Menu {
                ForEach(UserProfileViewModel.Theme.allCases, id: \.self) { theme in
                    Button {
                        viewModel.updateTheme(theme)
                    } label: {
                        HStack {
                            Image(systemName: theme.iconName)
                                .font(.system(size: 16))
                                .foregroundColor(Color("AppRed"))
                            Text(theme.displayName)
                                .font(.body)
                            if viewModel.selectedTheme == theme {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color("AppRed"))
                            }
                        }
                    }
                }
            } label: {
                Text(viewModel.selectedTheme.displayName)
                    .font(.body)
                    .foregroundColor(.gray)
                //            }
            }
        }
    }

    // MARK: - Переключатель уведомлений
    private var notificationsToggle: some View {
        Toggle(isOn: $viewModel.notificationsEnabled) {
            HStack {
                Image(systemName: "bell.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color("AppRed"))
                Text("Уведомления")
                    .font(.body)
            }
        }
        .onChange(of: viewModel.notificationsEnabled) { newValue in
            viewModel.toggleNotifications(newValue)
        }
    }
}

// MARK: - Preview
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(profile: UserProfileViewModel())
    }
}

// MARK: - Расширение для вспомогательных свойств
private extension UserProfileViewModel.Theme {
    var displayName: String {
        switch self {
        case .light: return "Светлая"
        case .dark: return "Тёмная"
        case .system: return "Системная"
        }
    }

    var iconName: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .system: return "gearshape.fill"
        }
    }
}
