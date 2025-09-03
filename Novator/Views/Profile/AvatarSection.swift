import SwiftUI
import PhotosUI

struct AvatarSection: View {
    @ObservedObject var profileVM: UserProfileViewModel
    @State private var selectedItem: PhotosPickerItem? = nil

    let availableAvatars = ["person.circle", "star.circle", "heart.circle", "flame.circle", "bolt.circle"]

    var body: some View {
        Section {
            VStack {
                // Аватар: фото или символ
                if let image = profileVM.avatarImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                } else {
                    Image(systemName: profileVM.profile.avatarSymbol)
                        .font(.system(size: 120))
                        .foregroundColor(Color("AppRed"))
                }

                // Кнопки выбора фото или символа
                HStack {
                    PhotosPicker(
                        selection: $selectedItem,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Text("Выбрать фото")
                    }
                    .onChange(of: selectedItem) { newItem in
                        if let item = newItem {
                            Task {
                                if let data = try? await item.loadTransferable(type: Data.self),
                                   let uiImage = UIImage(data: data) {
                                    profileVM.setAvatarImage(uiImage)
                                }
                            }
                        }
                    }

                    Menu {
                        ForEach(availableAvatars, id: \.self) { avatarOption in
                            Button {
                                profileVM.setAvatarSymbol(avatarOption)
                            } label: {
                                HStack {
                                    Image(systemName: avatarOption)
                                    Text(avatarOption)
                                }
                            }
                        }
                    } label: {
                        Text("Выбрать символ")
                    }
                }
            }
        }
    }
}
