import SwiftUI

struct FriendsView: View {
    @StateObject private var viewModel: FriendsViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @State var showSheetFriends = false

    init() {
        _viewModel = StateObject(wrappedValue: FriendsViewModel(profile: UserProfileViewModel()))
    }

    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    if viewModel.friends.isEmpty {
                        Text("У вас пока нет друзей")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                            .padding(.top, 20)
                    } else {
                        ForEach(viewModel.friends) { friend in
                            NavigationLink(destination: ProfileLookView(user: friend)) {
                                FriendRow(user: friend)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.top, 40)
            }
            .navigationTitle("Друзья")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSheetFriends.toggle()
                    } label: {
                        Image(systemName: "person.2.square.stack.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Color("AppRed"))
                    }
                }
            }
            .sheet(isPresented: $showSheetFriends) {
                FriendRequestsView()
                    .presentationDetents([.height(500)])
                    .presentationCornerRadius(20)
                    .environmentObject(userProfileViewModel)
            }
            .onAppear {
                viewModel.profile = userProfileViewModel
                viewModel.setupFriends()
            }
        }
    }
}

#Preview {
    FriendsView()
        .environmentObject(UserProfileViewModel())
}
