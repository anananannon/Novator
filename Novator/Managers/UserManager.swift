import Foundation

class UserManager: ObservableObject {
    static let shared = UserManager()
    
    @Published var users: [UUID: UserProfile] = [:]
    @Published var currentUserID: UUID
    
    private init() {
        do {
            if let data = UserDefaults.standard.data(forKey: "allUsers"),
               let savedUsers = try? JSONDecoder().decode([UUID: UserProfile].self, from: data) {
                self.users = savedUsers
                print("UserManager: Загружено \(savedUsers.count) пользователей")
            } else {
                print("UserManager: Данные пользователей отсутствуют или некорректны")
            }
            
            if let idData = UserDefaults.standard.data(forKey: "currentUserID"),
               let id = try? JSONDecoder().decode(UUID.self, from: idData) {
                self.currentUserID = id
                print("UserManager: Текущий пользователь ID: \(id)")
            } else {
                let newID = UUID()
                self.currentUserID = newID
                self.users[newID] = UserProfile(id: newID)
                save()
                print("UserManager: Создан новый пользователь с ID: \(newID)")
            }
        } catch {
            print("UserManager: Ошибка при инициализации: \(error)")
            // Сбрасываем данные, если десериализация не удалась
            let newID = UUID()
            self.currentUserID = newID
            self.users = [newID: UserProfile(id: newID)]
            UserDefaults.standard.removeObject(forKey: "allUsers")
            UserDefaults.standard.removeObject(forKey: "currentUserID")
            save()
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.set(data, forKey: "allUsers")
            let idData = try JSONEncoder().encode(currentUserID)
            UserDefaults.standard.set(idData, forKey: "currentUserID")
            print("UserManager: Данные успешно сохранены")
        } catch {
            print("Ошибка сохранения UserManager: \(error)")
        }
    }
    
    func getCurrentProfile() -> UserProfile {
        users[currentUserID] ?? UserProfile(id: currentUserID)
    }
    
    func updateCurrentProfile(_ profile: UserProfile) {
        users[currentUserID] = profile
        save()
    }
    
    func initializeUsers(_ profiles: [UserProfile]) {
        for profile in profiles {
            if users[profile.id] == nil {
                users[profile.id] = profile
                print("UserManager: Добавлен пользователь \(profile.username) с ID: \(profile.id)")
            }
        }
        save()
    }
}
