import SwiftUI

struct FriendsView: View {
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @EnvironmentObject var ratingViewModel: RatingViewModel
    @State private var showingFriendRequestsSheet = false

    // Находим друзей из ratingViewModel.users, используя profile.friends
    private var friends: [UserProfile] {
        ratingViewModel.users.filter { userProfileViewModel.profile.friends.contains($0.id) }
    }

    // Находим пользователей, отправивших заявки, из ratingViewModel.users
    private var incomingFriendRequests: [UserProfile] {
        ratingViewModel.users.filter { userProfileViewModel.profile.incomingFriendRequests.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Друзья").font(.system(.subheadline, weight: .semibold))) {
                    if friends.isEmpty {
                        Text("У вас пока нет друзей")
                            .font(.system(.body))
                            .foregroundColor(.gray)
                    } else {
                        ForEach(friends) { friend in
                            NavigationLink {
                                ProfileLookView(user: friend)
                                    .environmentObject(userProfileViewModel)
                            } label: {
                                FriendRow(friend: friend)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Друзья")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingFriendRequestsSheet = true
                    }) {
                        Image(systemName: "person.badge.plus")
                            .foregroundColor(Color("AppRed"))
                    }
                    .disabled(incomingFriendRequests.isEmpty)
                }
            }
            .sheet(isPresented: $showingFriendRequestsSheet) {
                FriendRequestsSheet(
                    incomingFriendRequests: incomingFriendRequests,
                    userProfileViewModel: userProfileViewModel,
                    ratingViewModel: ratingViewModel
                )
            }
        }
        .preferredColorScheme(userProfileViewModel.theme.colorScheme)
    }
}

// Sheet для отображения входящих заявок в друзья
struct FriendRequestsSheet: View {
    let incomingFriendRequests: [UserProfile]
    let userProfileViewModel: UserProfileViewModel
    let ratingViewModel: RatingViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Заявки в друзья").font(.system(.subheadline, weight: .semibold))) {
                    if incomingFriendRequests.isEmpty {
                        Text("Нет входящих заявок")
                            .font(.system(.body))
                            .foregroundColor(.gray)
                    } else {
                        ForEach(incomingFriendRequests) { user in
                            HStack {
                                Text(user.fullName)
                                    .font(.system(.body))
                                Spacer()
                                Button(action: {
                                    userProfileViewModel.acceptFriendRequest(from: user.id, ratingViewModel: ratingViewModel)
                                }) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                                Button(action: {
                                    userProfileViewModel.rejectFriendRequest(from: user.id, ratingViewModel: ratingViewModel)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Заявки в друзья")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
        }
        .preferredColorScheme(userProfileViewModel.theme.colorScheme)
    }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
        FriendsView()
            .environmentObject(UserProfileViewModel())
            .environmentObject(RatingViewModel(profile: UserProfileViewModel()))
    }
}
