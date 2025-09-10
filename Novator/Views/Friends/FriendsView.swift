import SwiftUI

struct FriendsView: View {
    @StateObject private var viewModel: FriendsViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @State private var showSheetFriends = false

    init() {
        // Используем userProfileViewModel из EnvironmentObject
        _viewModel = StateObject(wrappedValue: FriendsViewModel(profile: nil))
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
                    
                    HStack(spacing: 0) {
                        if userProfileViewModel.profile.incomingFriendRequests.count >= 1 {
                            Text("\(userProfileViewModel.profile.incomingFriendRequests.count)")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(Color("AppRed"), in: Circle())
                        }
                        
                        Button {
                            showSheetFriends.toggle()
                        } label: {
                            Image(systemName: "person.2.square.stack.fill")
                                .font(.system(size: 18))
                                .foregroundColor(Color("AppRed"))
                        }
                    }
                }
            }
            .sheet(isPresented: $showSheetFriends, onDismiss: {
                // Обновляем друзей при закрытии sheet
                viewModel.setupFriends()
            }) {
                FriendRequestsView()
                    .presentationDetents([.height(500)])
                    .presentationCornerRadius(15)
                    .environmentObject(userProfileViewModel)
            }
            .onAppear {
                // Устанавливаем profile из EnvironmentObject
                viewModel.profile = userProfileViewModel
                viewModel.setupFriends()
            }
            .onReceive(userProfileViewModel.$profile) { newProfile in
                // Реактивно обновляем друзей
                viewModel.friends = userDataSource.getDemoFriends(friendIds: newProfile.friends)
                print("🔔 FriendsView: список друзей обновлен: \(viewModel.friends.map { $0.id })")
            }
        }
    }

    private let userDataSource: UserDataSourceProtocol = UserDataSource()
}

#Preview {
    FriendsView()
        .environmentObject(UserProfileViewModel())
}
