import Foundation
import SwiftUI
class UserProfileViewModel: ObservableObject {
    @Published var profile: UserProfile
    @AppStorage("appTheme") var theme: Theme = .system
    enum Theme: String, CaseIterable {
        case light
        case dark
        case system
        var colorScheme: ColorScheme? {
            switch self {
            case .light:
                return .light
            case .dark:
                return .dark
            case .system:
                return nil
            }
        }
    }
    init() {
        if let data = UserDefaults.standard.data(forKey: "userProfile"),
           let savedProfile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.profile = savedProfile
        } else {
            self.profile = UserProfile(
                firstName: "Имя",
                lastName: "",
                username: "@username",
                avatar: nil, // Initialize with nil for default avatar
                stars: 0,
                raitingPoints: 0,
                streak: 0,
                friendsCount: 0,
                completedTasks: [],
                achievements: [],
                completedLessons: []
            )
        }
    }
    func saveProfile() {
        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: "userProfile")
        }
    }
    func updateProfile(firstName: String, lastName: String, username: String, avatar: Data?) {
        profile.firstName = firstName.trimmingCharacters(in: .whitespaces)
        profile.lastName = lastName.trimmingCharacters(in: .whitespaces)
        profile.username = username
        profile.avatar = avatar
        saveProfile()
    }
    // Other methods remain unchanged
    func addStars(_ stars: Int) {
        profile.stars += stars
        saveProfile()
    }
    func addRaitingPoints(_ raitingPoints: Int) {
        profile.raitingPoints += raitingPoints
        saveProfile()
    }
    func completeTask(_ taskId: UUID) {
        if !profile.completedTasks.contains(taskId) {
            profile.completedTasks.append(taskId)
            print("✅ Добавлена задача: \(taskId). Всего задач: \(profile.completedTasks.count)")
            saveProfile()
        } else {
            print("⚠️ Задача \(taskId) уже есть. Пропускаем.")
        }
    }
    func completeLesson(_ lessonId: String) {
        if !profile.completedLessons.contains(lessonId) {
            profile.completedLessons.append(lessonId)
            saveProfile()
        }
    }
    func isLessonCompleted(_ lessonId: String) -> Bool {
        profile.completedLessons.contains(lessonId)
    }
}
