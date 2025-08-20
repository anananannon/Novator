import SwiftUI
import Foundation

struct ProfileEditView: View {
    @ObservedObject var profile: UserProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State private var firstName: String
    @State private var lastName: String
    @State private var username: String
    @State private var showingAvatarPicker = false
    
    // Список доступных аватарок (SF Symbols)
    private let availableAvatars = [
        "person.circle",
        "star.circle",
        "heart.circle",
        "flame.circle",
        "bolt.circle"
    ]
    
    // Проверка, активна ли кнопка "Сохранить"
    private var isSaveButtonEnabled: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !username.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "@", with: "").isEmpty
    }

    init(profile: UserProfileViewModel) {
        self.profile = profile
        self._firstName = State(initialValue: profile.profile.firstName)
        self._lastName = State(initialValue: profile.profile.lastName)
        self._username = State(initialValue: profile.profile.username)
    }

    var body: some View {
        NavigationStack {
            List {
                // Секция с аватаркой и кнопкой
                Section {
                    VStack(spacing: 10) {
                        // Аватарка
                        Image(systemName: profile.profile.avatar)
                            .font(.system(size: 120))
                            .foregroundColor(Color("AppRed"))
                            .clipShape(Circle())
                            .padding(.top, 10)
                            .frame(maxWidth: .infinity)

                        // Кнопка "Изменить аватарку"
                        Button(action: {
                            showingAvatarPicker = true
                        }) {
                            Text("Изменить аватарку")
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(Color("AppRed"))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .listRowBackground(Color.clear)
                }

                // Секция для имени и фамилии (без заголовка)
                Section {
                    TextField("Имя", text: $firstName)
                        .font(.system(.title3, design: .rounded))
                    TextField("Фамилия", text: $lastName)
                        .font(.system(.title3, design: .rounded))
                }

                // Секция для юзернейма
                Section(header: Text("Юзернейм").font(.system(.subheadline, design: .rounded))) {
                    TextField("Юзернейм", text: $username)
                        .font(.system(.body, design: .rounded))
                        .onChange(of: username) { oldValue, newValue in
                            if !newValue.hasPrefix("@") {
                                username = "@" + newValue.replacingOccurrences(of: "@", with: "")
                            }
                        }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Редактировать профиль")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(Color("AppRed"))
                }
                ToolbarItemGroup(placement: .confirmationAction) {
                    Button("Сохранить") {
                        profile.updateProfile(firstName: firstName, lastName: lastName, username: username, avatar: profile.profile.avatar)
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(isSaveButtonEnabled ? Color("AppRed") : .gray)
                    .disabled(!isSaveButtonEnabled)
                }
            }
            .sheet(isPresented: $showingAvatarPicker) {
                AvatarPickerView(selectedAvatar: $profile.profile.avatar, availableAvatars: availableAvatars)
            }
        }
    }
}

// Отдельное представление для выбора аватарки
struct AvatarPickerView: View {
    @Binding var selectedAvatar: String
    let availableAvatars: [String]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(availableAvatars, id: \.self) { avatar in
                    Button(action: {
                        selectedAvatar = avatar
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: avatar)
                                .font(.system(size: 30))
                                .foregroundColor(Color("AppRed"))
                            Text(avatar)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(.primary)
                            Spacer()
                            if selectedAvatar == avatar {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color("AppRed"))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Выбрать аватарку")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(Color("AppRed"))
                }
            }
        }
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView(profile: UserProfileViewModel())
    }
}
