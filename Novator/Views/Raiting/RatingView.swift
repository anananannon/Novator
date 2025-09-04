import SwiftUI

struct RatingView: View {
    @StateObject private var viewModel: RatingViewModel

    init(profile: UserProfileViewModel) {
        _viewModel = StateObject(wrappedValue: RatingViewModel(profile: profile))
    }

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

    private func content(users: [UserProfile]) -> some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    if let firstPlaceUser = users.first {
                        GeometryReader { proxy in
                            let offset = proxy.frame(in: .global).minY
                            let startOffset = geometry.frame(in: .global).minY
                            let maxOffset: CGFloat = 120 // Анимация завершается на 120 пикселях
                            let relativeOffset = offset - startOffset
                            let scrollProgress = relativeOffset / maxOffset // Прогресс от -1 (вниз) до +1 (вверх)
                            let scale = max(0.7, min(1.1, 1 + scrollProgress * 0.2)) // Масштаб от 0.7 до 1.1

                            HStack {
                                Spacer()
                                NavigationLink(destination: ProfileLookView(user: users[0])) {
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
                                    .padding(.vertical, 20)
                                    .scaleEffect(scale) // Масштабирование всего VStack
                                    .animation(.linear, value: relativeOffset) // Линейная анимация
                                }
                                .buttonStyle(.plain)
                                Spacer()
                            }
                        }
                        .frame(height: 200) // Фиксированная высота для корректного отслеживания
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
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(profile: UserProfileViewModel())
    }
}
