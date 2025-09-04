import SwiftUI

struct RatingView: View {
    @StateObject private var viewModel: RatingViewModel

    // Инициализатор принимает UserProfileViewModel
    init(profile: UserProfileViewModel) {
            _viewModel = StateObject(wrappedValue: RatingViewModel(profile: profile))
        }


    var body: some View {
        NavigationStack {
            VStack {
                // TabView синхронизирован с Picker
                TabView(selection: $viewModel.pickerMode) {
                    content(users: viewModel.sortedUsers).tag(0)
                    content(users: viewModel.sortedFriends).tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Picker("Global", selection: $viewModel.pickerMode) {
                            Text("Общий").tag(0)
                        }
                        .frame(minWidth: 30)
                        .pickerStyle(.segmented)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Picker("Friends", selection: $viewModel.pickerMode) {
                            Text("Друзья").tag(1)
                        }
                        .frame(minWidth: 30)
                        .pickerStyle(.segmented)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Список пользователей
    private func content(users: [UserProfile]) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                if let firstPlaceUser = users.first{
                    NavigationLink(destination: ProfileLookView(user:users[0])) {
                        VStack {
                            ZStack(alignment: .bottom) {
                                if let avatarData = firstPlaceUser.avatar, let uiImage = UIImage(data: avatarData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 110, height: 110)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.circle.fill")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 110, height: 110)
                                        .foregroundColor(Color("AppRed"))
                                }
                                
                                Image(systemName: "star.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(Color(red: 255/255, green: 215/255, blue: 0/255))
                                    .offset(y: 6)
                            }
                            
                            Text("\(firstPlaceUser.fullName)")
                                .font(.system(size: 22))
                                .fontWeight(.semibold)
                            HStack {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 17))
                                    .foregroundColor(Color("AppRed"))
                                
                                Text("\(firstPlaceUser.raitingPoints)")
                                    .font(.system(size: 17))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .buttonStyle(.plain)
                    .padding(.vertical, 20)
                }
                
                Divider()
                ForEach(users.dropFirst().indices, id: \.self) { index in
                    NavigationLink(destination: ProfileLookView(user: users[index])) {
                        RatingRowView(rank: index + 1, user: users[index], currentUser: viewModel.profile.profile)
                    }
                    .buttonStyle(.plain)
                    Divider()
                        .padding(.leading, 40)
                }
            }
        }
    }
}

// MARK: - Preview
struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(profile: UserProfileViewModel())
    }
}
