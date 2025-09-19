import SwiftUI

struct FriendRequestsView: View {
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @Environment(\.dismiss) var dismiss
    private let userDataSource: UserDataSourceProtocol = UserDataSource()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    let incomingUsers = userDataSource.getDemoFriends(friendIds: userProfileViewModel.profile.incomingFriendRequests)
                    if incomingUsers.isEmpty {
                        Text("Нет входящих заявок в друзья")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        VStack {
                            ForEach(incomingUsers) { user in
                                // Оборачиваем весь контент пользователя в NavigationLink
                                NavigationLink {
                                    ProfileLookView(user: user)
                                        .environmentObject(userProfileViewModel)
                                } label: {
                                    HStack {
                                        if let avatarData = user.avatar, let uiImage = UIImage(data: avatarData) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        } else {
                                            Image(systemName: "person.circle.fill")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(Color("AppRed"))
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text(user.fullName)
                                                .font(.system(size: 15))
                                                .fontWeight(.semibold)
                                            Text(user.username)
                                                .font(.system(size: 12))
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                    }
                                    .background(Color(.black).opacity(0.00000001))
                                }
                                .buttonStyle(.plain)
                                
                                HStack {
                                    Button {
                                        userProfileViewModel.acceptFriendRequest(from: user.id)
                                    } label: {
                                        Text("Принять")
                                            .font(.system(size: 15))
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 35)
                                            .background(Color("AppRed"))
                                            .foregroundColor(.white)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    
                                    Button {
                                        userProfileViewModel.rejectFriendRequest(from: user.id)
                                    } label: {
                                        Text("Отклонить")
                                            .font(.system(size: 15))
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 35)
                                            .background(Color.gray.opacity(0.2))
                                            .foregroundColor(.gray)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                                .padding(.vertical, 2)
                                Divider()
                            }
                            .buttonStyle(.plain) // Убираем стандартный стиль кнопки для NavigationLink
                        }
                        .padding(.top, 10)
                        Spacer()
                    }
                }
            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Закрыть")
                            .foregroundColor(Color("AppRed"))
                    }
                }
            }
        }
        .navigationTitle("Заявки в друзья")
        .navigationBarTitleDisplayMode(.inline)
    }
}


#Preview {
    FriendRequestsView()
        .environmentObject(UserProfileViewModel())
}
