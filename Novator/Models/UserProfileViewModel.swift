import Foundation

class UserProfileViewModel: ObservableObject {
    @Published var profile: UserProfile
    
    init() {
        if let data = UserDefaults.standard.data(forKey: "userProfile"),
           let savedProfile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.profile = savedProfile
        } else {
            self.profile = UserProfile(
                firstName: "Имя",
                lastName: "",
                username: "@username",
                avatar: "person.circle",
                level: "beginner",
                points: 0,
                streak: 0,
                friendsCount: 0,
                completedTasks: [],
                achievements: []
            )
        }
    }
    
    func saveProfile() {
        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: "userProfile")
        }
    }
    
    func updateProfile(firstName: String, lastName: String, username: String, avatar: String) {
        profile.firstName = firstName.trimmingCharacters(in: .whitespaces)
        profile.lastName = lastName.trimmingCharacters(in: .whitespaces)
        profile.username = username
        profile.avatar = avatar
        saveProfile()
    }
    
    func updateLevel(_ level: String) {
        profile.level = level
        saveProfile()
    }
    
    func addPoints(_ points: Int) {
        profile.points += points
        saveProfile()
    }
    
    func completeTask(_ taskId: UUID) {
        profile.completedTasks.append(taskId)
        saveProfile()
    }
}
