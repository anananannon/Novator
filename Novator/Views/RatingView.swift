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
                    ToolbarItem(placement: .principal) {
                        Picker("HzChe", selection: $viewModel.pickerMode) {
                            Text("Общий").tag(0)
                            Text("Друзья").tag(1)
                        }
                        .padding(.horizontal, 40)
                        .pickerStyle(.segmented)
                    }
                }
                .animation(.spring(Spring(mass: 0.001, stiffness: 0.886, damping: 1)), value: viewModel.pickerMode)
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }

    // MARK: - Список пользователей
    private func content(users: [UserProfile]) -> some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(users.indices, id: \.self) { index in
                    RatingRowView(rank: index + 1, user: users[index])
                }
            }
            .padding()
        }
    }
}

// MARK: - Ячейка рейтинга
struct RatingRowView: View {
    let rank: Int
    let user: UserProfile

    var body: some View {
        HStack {
            Text("#\(rank)")
                .font(.title2)
                .foregroundColor(.gray)
                .padding(.leading, 10)

            Divider()

            Image(systemName: user.avatar)
                .font(.system(size: 40))
                .foregroundColor(Color("AppRed"))

            VStack(alignment: .leading) {
                Text(user.fullName)
                    .font(.system(.title3))
                Text(user.username)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(Color("AppRed"))
                Text("\(user.points)")
            }
            .padding(.trailing, 15)
        }
        .frame(maxWidth: 340, maxHeight: 50)
        .padding(.vertical, 10)
    }
}

// MARK: - Preview
struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(profile: UserProfileViewModel())
    }
}
