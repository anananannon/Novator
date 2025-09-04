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
                Picker("HzChe", selection: $viewModel.pickerMode) {
                    Text("Общий").tag(0)
                    Text("Друзья").tag(1)
                }
                .padding(.horizontal, 50)
                .pickerStyle(.segmented)
                // TabView синхронизирован с Picker
                TabView(selection: $viewModel.pickerMode) {
                    content(users: viewModel.sortedUsers).tag(0)
                    content(users: viewModel.sortedFriends).tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
        }
    }

    // MARK: - Список пользователей
    private func content(users: [UserProfile]) -> some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(users.indices, id: \.self) { index in
                    NavigationLink(destination: ProfileLookView(user: users[index])) {
                        RatingRowView(rank: index + 1, user: users[index], currentUser: viewModel.profile.profile)
                    }
                    .buttonStyle(.plain)
                    Divider()
                }
            }
            .padding(.top, 10)
        }
    }
}

// MARK: - Preview
struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(profile: UserProfileViewModel())
    }
}
