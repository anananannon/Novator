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
        // Для отладки: раскомментировать для сброса профиля
        // UserDefaults.standard.removeObject(forKey: "userProfile")
        
        if let data = UserDefaults.standard.data(forKey: "userProfile"),
           let savedProfile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.profile = savedProfile
            print("✅ Загружен профиль: \(savedProfile.pendingFriendRequests), друзья: \(savedProfile.friends), входящие заявки: \(savedProfile.incomingFriendRequests)")
        } else {
            self.profile = UserProfile(
                firstName: "Имя",
                lastName: "",
                username: "@username",
                avatar: nil,
                stars: 0,
                raitingPoints: 0,
                streak: 0,
                friendsCount: 2,
                friends: [
                    UUID(uuidString: "550E8400-E29B-41D4-A716-446655440000")!, // Павел
                    UUID(uuidString: "550E8400-E29B-41D4-A716-446655440001")!  // Илон
                ],
                pendingFriendRequests: [],
                incomingFriendRequests: [
                    UUID(uuidString: "550E8400-E29B-41D4-A716-446655440002")!, // Иван
                    UUID(uuidString: "550E8400-E29B-41D4-A716-446655440003")!  // Джек
                ],
                completedTasks: [],
                achievements: [],
                completedLessons: []
            )
            print("🆕 Создан новый профиль с друзьями: \(self.profile.friends), входящими заявками: \(self.profile.incomingFriendRequests)")
            saveProfile()
        }
    }

    func saveProfile() {
        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: "userProfile")
            print("✅ Профиль сохранён в UserDefaults: \(profile.pendingFriendRequests), друзья: \(profile.friends), входящие заявки: \(profile.incomingFriendRequests)")
        } else {
            print("❌ Ошибка кодирования профиля")
        }
    }

    func updateProfile(firstName: String, lastName: String, username: String, avatar: Data?) {
        profile.firstName = firstName.trimmingCharacters(in: .whitespaces)
        profile.lastName = lastName.trimmingCharacters(in: .whitespaces)
        profile.username = username
        profile.avatar = avatar
        saveProfile()
    }

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

    
    // Отправляет заявку в друзья
    func sendFriendRequest(to userId: UUID) {
        if !profile.friends.contains(userId) && !profile.pendingFriendRequests.contains(userId) && userId != profile.id {
            profile.pendingFriendRequests.append(userId)
            saveProfile()
            print("📩 Отправлена заявка в друзья пользователю с ID: \(userId), pendingFriendRequests: \(profile.pendingFriendRequests)")
        } else {
            print("⚠️ Заявка не отправлена: пользователь уже в друзьях, заявка уже отправлена или это текущий пользователь")
        }
    }
    
    // Убирает отправленную заявку в друзья
    func cancelFriendRequest(to userId: UUID) {
        if profile.pendingFriendRequests.contains(userId) {
            profile.pendingFriendRequests.removeAll { $0 == userId }
            saveProfile()
            print("❌ Заявка в друзья пользователю \(userId) отменена")
        } else {
            print("⚠️ Заявка не найдена для пользователя \(userId)")
        }
    }

    // Принимает приходяшие заявки в друзья
    func acceptFriendRequest(from userId: UUID) {
        if !profile.friends.contains(userId) && profile.incomingFriendRequests.contains(userId) {
            profile.friends.append(userId)
            profile.friendsCount = profile.friends.count
            profile.incomingFriendRequests.removeAll { $0 == userId }
            saveProfile()
            print("✅ Пользователь \(userId) добавлен в друзья")
        } else {
            print("⚠️ Заявка не принята: пользователь уже в друзьях или заявка не найдена")
        }
    }

    
    // Не принимает приходящие заявки в друзья
    func rejectFriendRequest(from userId: UUID) {
        if profile.incomingFriendRequests.contains(userId) {
            profile.incomingFriendRequests.removeAll { $0 == userId }
            saveProfile()
            print("❌ Заявка от пользователя \(userId) отклонена")
        } else {
            print("⚠️ Заявка не отклонена: заявка не найдена")
        }
    }
}
