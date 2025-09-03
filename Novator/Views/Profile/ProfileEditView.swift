import SwiftUI
import PhotosUI // Import PhotosUI for PhotosPicker

// MARK: - ProfileEditView
struct ProfileEditView: View {
    @ObservedObject var profile: UserProfileViewModel
    @Environment(\.dismiss) var dismiss
    @State private var firstName: String
    @State private var lastName: String
    @State private var username: String
    @State private var selectedPhoto: PhotosPickerItem? // For PhotosPicker
    @State private var avatarImage: UIImage? // To hold the selected image

    // MARK: - Initialization
    init(profile: UserProfileViewModel) {
        self.profile = profile
        self._firstName = State(wrappedValue: profile.profile.firstName)
        self._lastName = State(wrappedValue: profile.profile.lastName)
        self._username = State(wrappedValue: profile.profile.username)
        // Initialize avatarImage from profile.avatar if it exists
        if let avatarData = profile.profile.avatar, let image = UIImage(data: avatarData) {
            self._avatarImage = State(wrappedValue: image)
        }
    }

    // MARK: - Computed Properties
    private var isSaveButtonEnabled: Bool {
        !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
        username.trimmingCharacters(in: .whitespaces).dropFirst().count >= 3
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            AvatarSection(
                avatarImage: $avatarImage,
                selectedPhoto: $selectedPhoto
            )
            
            List {
//                AvatarSection(
//                    avatarImage: $avatarImage,
//                    selectedPhoto: $selectedPhoto
//                )
                Section(footer: Text("Укажите имя которое хотите отоброжать в профиле")) {
                    TextFieldView(title: "Имя", text: $firstName, font: .body)
                    TextFieldView(title: "Фамилия", text: $lastName, font: .body)
                }
                Section(header: Text("Пользовательское имя").font(.subheadline), footer: Text("Имя пользователя нужно, что бы присвоить вашему аккаунту уникальность и что бы люди могли вас находить во вкладке (друзья)")) {
                    UsernameTextFieldView(text: $username)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Редактировать профиль")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена", action: { dismiss() })
                        .font(.body)
                        .foregroundColor(Color("AppRed"))
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        // Convert avatarImage to Data for saving
                        let avatarData = avatarImage?.jpegData(compressionQuality: 0.8)
                        profile.updateProfile(
                            firstName: firstName,
                            lastName: lastName,
                            username: username,
                            avatar: avatarData
                        )
                        dismiss()
                    }
                    .font(.body)
                    .foregroundColor(isSaveButtonEnabled ? Color("AppRed") : .gray)
                    .disabled(!isSaveButtonEnabled)
                }
            }
        }
        .preferredColorScheme(profile.theme.colorScheme)
    }
}

// MARK: - AvatarSection
struct AvatarSection: View {
    @Binding var avatarImage: UIImage?
    @Binding var selectedPhoto: PhotosPickerItem?

    var body: some View {
        Section {
            HStack {
                Spacer()
                if let image = avatarImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .foregroundColor(Color("AppRed"))
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .foregroundColor(Color("AppRed"))
                }
                Spacer()
            }
            
            ZStack(alignment: .trailing) {
                HStack {
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Text("Выбрать фотографию")
                            .font(.body)
                            .foregroundColor(Color("AppRed"))
                            .frame(alignment: .center)
                            .padding(.leading, 5)
                    }
                    .onChange(of: selectedPhoto) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                avatarImage = uiImage
                            }
                        }
                    }
                    
                    Button(action: {
                        avatarImage = nil
                        selectedPhoto = nil
                    }) {
                        Image(systemName: "trash.fill")
                            .font(.body)
                            .foregroundColor(Color("AppRed"))
                            .padding(.trailing)
                    }
                    .disabled(avatarImage == nil) // Опционально: отключает кнопку, если аватар уже сброшен
                }
                .frame(maxWidth: .infinity)
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
                .font(.body)
            TextField("", text: $editablePart)
                .font(.body)
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
