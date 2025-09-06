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
                    ToolbarItem(placement: .topBarTrailing) {
                        Menu {
                            Picker(selection: $viewModel.pickerMode,
                                   label: Image(systemName: "person")) {
                                Text("Общий").tag(0)
                                Text("Друзья").tag(1)
                            }.pickerStyle(.automatic)
                        } label: {
                            Image(systemName: "list.bullet")
                        }
                    }
                }
                .toolbarBackground(Color("ProfileBackground"), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
            }
            .navigationTitle("Рейтинг")
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
                                                .foregroundColor(Color(red: 255/255, green: 215/255, blue: 0/255))
                                                .offset(y: 6)
                                        }
                                        
                                        Text("\(firstPlaceUser.fullName)")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                        HStack {
                                            Image(systemName: "crown.fill")
                                                .font(.system(size: 15))
                                                .foregroundColor(Color("AppRed"))
                                            Text("\(firstPlaceUser.raitingPoints)")
                                                .font(.system(size: 15))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .scaleEffect(scale) // Масштабирование всего VStack
                                    .animation(.linear, value: relativeOffset) // Линейная анимация
                                }
                                .buttonStyle(.plain)
                                Spacer()
                            }
                            .padding(.top, 15)
                        }
                        .frame(height: 160) // Фиксированная высота для корректного отслеживания
                    }

                    HStack {
                        Text("НЕ ПЕРВОЕ МЕСТО")
                            .font(.system(.subheadline, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 17)
                            .padding(.vertical, 5)
                        Spacer()
                    }
                    .background(Color("SectionBackground"))
                    .padding(.top, 14)
                    
                    ForEach(users.dropFirst().indices, id: \.self) { index in
                        NavigationLink(destination: ProfileLookView(user: users[index])) {
                            RatingRowView(rank: index + 1, user: users[index], currentUser: viewModel.profile.profile)
                        }
                        .buttonStyle(.plain)
                        Divider()
                            .padding(.leading, 50)
                    }
                }
            }
        }
        .background(Color("ProfileBackground"))
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(profile: UserProfileViewModel())
    }
}
