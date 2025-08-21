import SwiftUI

// MARK: - ProfileEditView
struct ProfileEditView: View {
    @ObservedObject var profile: UserProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State private var firstName: String
    @State private var lastName: String
    @State private var username: String
    @State private var showingAvatarPicker = false

    private let availableAvatars = ["person.circle", "star.circle", "heart.circle", "flame.circle", "bolt.circle"]

    // MARK: - Initialization
    init(profile: UserProfileViewModel) {
        self.profile = profile
        self._firstName = State(wrappedValue: profile.profile.firstName)
        self._lastName = State(wrappedValue: profile.profile.lastName)
        self._username = State(wrappedValue: profile.profile.username)
    }

    // MARK: - Computed Properties
    private var isSaveButtonEnabled: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
        username.trimmingCharacters(in: .whitespaces).dropFirst().count >= 3
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            List {
                AvatarSection(
                    avatar: $profile.profile.avatar,
                    showingAvatarPicker: $showingAvatarPicker,
                    availableAvatars: availableAvatars
                )
                Section(footer: Text("Укажите имя которое хотите отоброжать в профиле")) {
                    TextFieldView(title: "Имя", text: $firstName, font: .bodyRounded)
                    TextFieldView(title: "Фамилия", text: $lastName, font: .bodyRounded)
                }
                Section(header: Text("Пользовательское имя").font(.subheadlineRounded), footer: Text("Имя пользователя нужно, что бы присвоить вашему аккаунту уникальность и что бы люди могли вас находить во вкладке (друзья)")) {
                    UsernameTextFieldView(text: $username)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Редактировать профиль")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена", action: { dismiss() })
                        .font(.bodyRounded)
                        .foregroundColor(Color("AppRed"))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        profile.updateProfile(
                            firstName: firstName,
                            lastName: lastName,
                            username: username,
                            avatar: profile.profile.avatar
                        )
                        dismiss()
                    }
                    .font(.bodyRounded)
                    .foregroundColor(isSaveButtonEnabled ? Color("AppRed") : .gray)
                    .disabled(!isSaveButtonEnabled)
                }
            }
        }
    }
}

// MARK: - AvatarSection
struct AvatarSection: View {
    @Binding var avatar: String
    @Binding var showingAvatarPicker: Bool
    let availableAvatars: [String]

    var body: some View {
        Section {
            HStack {
                Spacer()
                Image(systemName: avatar.isEmpty ? "person.circle" : avatar)
                    .font(.system(size: 120))
                    .foregroundColor(Color("AppRed"))
                Spacer()
            }
            Menu {
                ForEach(availableAvatars, id: \.self) { avatarOption in
                    Button {
                        avatar = avatarOption
                    } label: {
                        HStack {
                            Image(systemName: avatarOption)
                                .font(.system(size: 30))
                                .foregroundColor(Color("AppRed"))
                            Text(avatarOption)
                                .font(.bodyRounded)
                            if avatar == avatarOption {
                                Image(systemName: "checkmark")
                                    .foregroundColor(Color("AppRed"))
                            }
                        }
                    }
                }
            } label: {
                Text("Изменить аватарку")
                    .font(.bodyRounded)
                    .foregroundColor(Color("AppRed"))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }
}

// MARK: - TextFieldView
struct TextFieldView: View {
    let title: String
    @Binding var text: String
    let font: Font

    var body: some View {
        TextField(title, text: $text)
            .font(font)
    }
}

// MARK: - UsernameTextFieldView
struct UsernameTextFieldView: View {
    @Binding var text: String
    @State private var editablePart: String

    init(text: Binding<String>) {
        self._text = text
        self._editablePart = State(wrappedValue: text.wrappedValue.dropFirst().replacingOccurrences(of: "@", with: ""))
    }

    var body: some View {
        HStack(spacing: 0) {
            Text("Имя пользователя      ")
                .font(.bodyRounded)
                .foregroundStyle(.black)
            TextField("", text: $editablePart)
                .font(.bodyRounded)
                .autocapitalization(.none)
                .keyboardType(.asciiCapable)
                .onChange(of: editablePart) { newValue in
                    let cleanValue = newValue.replacingOccurrences(of: "@", with: "").trimmingCharacters(in: .whitespaces)
                    editablePart = cleanValue
                    text = "@" + cleanValue
                }
        }
    }
}

// MARK: - Preview
struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView(profile: UserProfileViewModel())
    }
}
