import SwiftUI
import Combine

struct SearchUsersSheet: View {
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel
    @StateObject private var viewModel = SearchUsersViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack {
                // Кастомное поле поиска, имитирующее .searchable
                SearchBar(text: $viewModel.searchQuery, placeholder: "Поиск по username")
                    .padding(.horizontal)
                    .padding(.bottom)
                    .background(Color(.systemGray5))
                
                // Список результатов
                ScrollView {
                    VStack {
                        if viewModel.searchResults.isEmpty {
                            if viewModel.searchQuery.isEmpty {
                                Text("Начните вводить username")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                                    .padding(.top, 20)
                            } else {
                                Text("Пользователи не найдены")
                                    .font(.system(size: 16))
                                    .foregroundColor(.secondary)
                                    .padding(.top, 20)
                            }
                        } else {
                            ForEach(viewModel.searchResults) { user in
                                UserRow(user: user, currentUserId: userProfileViewModel.profile.id)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Поиск пользователей")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
            .accentColor(Color("AppRed"))
        }
    }
}

// Кастомный компонент SearchBar, имитирующий .searchable
struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField(placeholder, text: $text)
                .font(.system(size: 15))
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .focused($isFocused)
                .padding(.vertical, 6)
            if !text.isEmpty {
                Button(action: {
                    text = ""
                    isFocused = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}


class SearchUsersViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var searchResults: [UserProfile] = []
    private let userDataSource: UserDataSourceProtocol = UserDataSource()

    init() {
        setupSearch()
    }

    private func setupSearch() {
        $searchQuery
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] query in
                guard let self = self else { return }
                Task {
                    await self.performSearch(query: query)
                }
            }
            .store(in: &cancellables)
    }

    @MainActor
    private func performSearch(query: String) async {
        do {
            searchResults = try await userDataSource.searchUsers(by: query)
            print("🔍 Поиск вернул \(searchResults.count) пользователей")
        } catch {
            print("❌ Ошибка поиска: \(error)")
            searchResults = []
        }
    }

    private var cancellables = Set<AnyCancellable>()
}

struct UserRow: View {
    let user: UserProfile
    let currentUserId: UUID
    @EnvironmentObject var userProfileViewModel: UserProfileViewModel

    var body: some View {
        NavigationLink(destination: ProfileLookView(user: user)) {
            HStack {
                if let avatarData = user.avatar, let uiImage = UIImage(data: avatarData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .padding(.leading, 10)
                } else {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(Color("AppRed"))
                        .padding(.leading, 10)
                }
                VStack(alignment: .leading) {
                    Text(user.fullName)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                    Text(user.username)
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                    Divider()
                }
            }
            .accentColor(Color("AppRed"))
            .background(.black.opacity(0.000001))
        }
    }
}

#Preview {
    SearchUsersSheet()
        .environmentObject(UserProfileViewModel())
}
