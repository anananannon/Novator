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
                Section {
                    TextFieldView(title: "Имя", text: $firstName, font: .bodyRounded)
                    TextFieldView(title: "Фамилия", text: $lastName, font: .bodyRounded)
                }
                Section(header: Text("Юзернейм").font(.subheadlineRounded)) {
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
            Button("Изменить аватарку") {
                showingAvatarPicker = true
            }
            .font(.bodyRounded)
            .foregroundColor(Color("AppRed"))
            .sheet(isPresented: $showingAvatarPicker) {
                AvatarPickerView(selectedAvatar: $avatar, availableAvatars: availableAvatars)
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
            Text("@")
                .font(.bodyRounded)
                .foregroundColor(.gray)
            TextField("Юзернейм", text: $editablePart)
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

// MARK: - AvatarPickerView
struct AvatarPickerView: View {
    @Binding var selectedAvatar: String
    let availableAvatars: [String]
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(availableAvatars, id: \.self) { avatar in
                    Button {
                        selectedAvatar = avatar
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: avatar)
                                .font(.system(size: 30))
                                .foregroundColor(Color("AppRed"))
                            Text(avatar)
                                .font(.bodyRounded)
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
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена", action: { dismiss() })
                        .font(.bodyRounded)
                        .foregroundColor(Color("AppRed"))
                }
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
