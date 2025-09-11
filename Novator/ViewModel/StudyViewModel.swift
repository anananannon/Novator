import SwiftUI
import Foundation

@MainActor
class StudyViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var navigationPath = NavigationPath()
    @Published var showStarsPopover = false
    @Published var showRaitingPopover = false
    @Published var selectedLesson: Lesson?
    @Published var activeButtons: Set<String> = []
    @Published var nextIncompleteLessonId: String?
    @Published var hasScrolledOnFirstAppear = false
    
    // MARK: - Dependencies
    let profile: UserProfileViewModel
    
    // MARK: - Computed Properties
    var reversedLessons: [Lesson] {
        Array(TaskManager.lessons.reversed())
    }
    
    // MARK: - Initialization
    init(profile: UserProfileViewModel) {
        self.profile = profile
        self.nextIncompleteLessonId = Self.computeNextIncompleteLessonId(for: profile)
    }
    
    // MARK: - Methods
    func shouldShowDivider(before lesson: Lesson) -> Bool {
        guard let id = Int(lesson.id) else { return false }
        return id % 10 == 0
    }
    
    static func computeNextIncompleteLessonId(for profile: UserProfileViewModel) -> String? {
        let incompleteLesson = TaskManager.lessons
            .sorted { (Int($0.id) ?? 0) < (Int($1.id) ?? 0) }
            .first { !profile.isLessonCompleted($0.id) }
        print("🔔 computeNextIncompleteLessonId: lessons count = \(TaskManager.lessons.count), incomplete lesson = \(String(describing: incompleteLesson?.id))")
        return incompleteLesson?.id
    }
    
    func handleSquareTap(for lesson: Lesson) {
        if activeButtons.contains(lesson.id) {
            selectedLesson = lesson
            activeButtons.removeAll()
        } else {
            activeButtons = [lesson.id]
        }
    }
    
    func resetActiveButtons() {
        activeButtons.removeAll()
    }
    
    func updateNextIncompleteLessonId() {
        nextIncompleteLessonId = Self.computeNextIncompleteLessonId(for: profile)
    }
}
