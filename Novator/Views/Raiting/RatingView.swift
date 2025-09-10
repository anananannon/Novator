import SwiftUI

// MARK: - Основной рейтинг
struct RatingView: View {
    @StateObject private var viewModel: RatingViewModel

    // MARK: - Инициализация
    init(profile: UserProfileViewModel) {
        _viewModel = StateObject(wrappedValue: RatingViewModel(profile: profile))
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            VStack {
                TabView(selection: $viewModel.pickerMode) {
                    content(users: viewModel.sortedUsers).tag(0)
                    content(users: viewModel.sortedFriends).tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu {
                            Picker(selection: $viewModel.pickerMode,
                                   label: Image(systemName: "person")) {
                                Text("Общий").tag(0)
                                Text("Друзья").tag(1)
                            }.pickerStyle(.automatic)
                        } label: {
                            Text("Сортировка")
                        }
                    }
                }
            }
            .background(Color("ProfileBackground")).ignoresSafeArea()
            .navigationTitle("Рейтинг")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Контент вкладки
    private func content(users: [UserProfile]) -> some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    if let firstPlaceUser = users.first {
                        TopUserView(user: firstPlaceUser, currentUser: viewModel.profile.profile, geometry: geometry)
                            .frame(height: 160)
                    }

                    SectionHeaderView(title: "НЕ ПЕРВОЕ МЕСТО")

                    ForEach(Array(users.dropFirst().enumerated()), id: \.offset) { index, user in
                        NavigationLink(destination: ProfileLookView(user: user)) {
                            RatingRowView(rank: index + 2, user: user, currentUser: viewModel.profile.profile)
                        }
                        .buttonStyle(.plain)
                        Divider().padding(.leading, 50)
                    }
                }
            }
        }
//        .background(Color("ProfileBackground")).ignoresSafeArea()
    }
}

// MARK: - Preview
struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(profile: UserProfileViewModel())
    }
}

// MARK: - Вспомогательные вью
private struct SectionHeaderView: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.system(.subheadline, weight: .semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 17)
                .padding(.vertical, 5)
            Spacer()
        }
        .background(Color("SectionBackground"))
        .padding(.top, 17)
    }
}
private struct TopUserView: View {
    let user: UserProfile
    let currentUser: UserProfile
    let geometry: GeometryProxy

    private let maxScaleUp: CGFloat = 1.1 // Максимальное увеличение
    private let minScaleDown: CGFloat = 0.7 // Минимальное уменьшение
    private let animationDistance: CGFloat = 140 // Дистанция для полной анимации

    var body: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .global).minY
            let offset = minY - geometry.frame(in: .global).minY

            // Вычисляем scale
            let scale: CGFloat = {
                if offset > 0 {
                    let progressUp = min(offset / animationDistance, 1)
                    return 1.0 + (maxScaleUp - 1.0) * progressUp
                } else {
                    let progressDown = min(-offset / animationDistance, 1)
                    return 1.0 - (1.0 - minScaleDown) * progressDown
                }
            }()

            HStack {
                Spacer()
                NavigationLink(destination: ProfileLookView(user: user)) {
                    VStack(spacing: 5) {
                        ZStack(alignment: .bottom) {
                            if let avatarData = user.avatar, let uiImage = UIImage(data: avatarData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(Color("AppRed"))
                            }

                            Image(systemName: "star.circle.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color.yellow)
                                .offset(y: 6)
                        }

                        Text(user.fullName)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)

                        HStack {
                            Image(systemName: "crown.fill")
                                .font(.system(size: 15))
                                .foregroundColor(Color("AppRed"))
                            Text("\(user.raitingPoints)")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                        }
                    }
                    .scaleEffect(scale)
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.top, 15)
        }
        .frame(height: 160)
    }
}
