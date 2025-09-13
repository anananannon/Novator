import SwiftUI

struct FriendsView: View {
    @StateObject private var viewModel: FriendsViewModel
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @State private var showSheetFriends = false
    @State private var showSearchSheet = false // Новый: для sheet поиска

    init() {
        _viewModel = StateObject(wrappedValue: FriendsViewModel(profile: nil))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Button {
                        showSearchSheet.toggle()
                    } label: {
                        HStack {
                            Image(systemName: "person.fill.badge.plus")
                            Text("Добавить пользователя")
                                .foregroundColor(Color("AppRed"))
                                .padding(.leading, 13)
                            Spacer()
                        }
                        .font(.system(size: 15))
                        .padding(.leading, 24)
                    }
                    .padding(.top, 5)
                    Divider()

                    VStack {
                        if viewModel.filteredFriends.isEmpty {
                            if viewModel.searchQuery.isEmpty {
                                Text("У вас пока нет друзей")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                                    .padding(.top, 20)
                            } else {
                                Text("Друзья не найдены")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                                    .padding(.top, 20)
                            }
                        } else {
                            ForEach(viewModel.filteredFriends) { friend in
                                NavigationLink(destination: ProfileLookView(user: friend)) {
                                    FriendRow(user: friend)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                }
            }
            .searchable(text: $viewModel.searchQuery) // Оставляем локальный поиск по друзьям
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
            .sheet(isPresented: $showSearchSheet) {
                SearchUsersSheet()
//                    .presentationDetents([.medium, .large])
                    .presentationCornerRadius(15)
                    .environmentObject(userProfileViewModel)
            }
            .onAppear {
                viewModel.profile = userProfileViewModel
                viewModel.setupFriends()
            }
            .onReceive(userProfileViewModel.$profile) { newProfile in
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
