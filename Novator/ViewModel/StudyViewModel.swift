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
    @Published var currentPage: Int = 0
    
    // MARK: - Dependencies
    let profile: UserProfileViewModel
    
    // MARK: - Computed Properties
    var lessons: [Lesson] {
        TaskManager.lessons.sorted { (Int($0.id) ?? 0) < (Int($1.id) ?? 0) }
    }
    
    var lessonsByPage: [[Lesson]] {
        lessons.chunked(into: 50)
    }
    
    var completedCountOnPage: Int {
        currentLessons.filter { profile.isLessonCompleted($0.id) }.count
    }

    var totalCountOnPage: Int {
        currentLessons.count
    }
    
    var currentLessons: [Lesson] {
        guard currentPage < lessonsByPage.count else { return [] }
        return lessonsByPage[currentPage].reversed()
    }
    
    // MARK: - Initialization
    init(profile: UserProfileViewModel) {
        self.profile = profile
        self.nextIncompleteLessonId = Self.computeNextIncompleteLessonId(for: profile)
        
        if let nextId = nextIncompleteLessonId,
           let globalIndex = lessons.firstIndex(where: { $0.id == nextId }) {
            currentPage = globalIndex / 50
        }
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
        if let nextId = nextIncompleteLessonId,
           let globalIndex = lessons.firstIndex(where: { $0.id == nextId }) {
            currentPage = globalIndex / 50
        }
    }
    
    func goToNextPage() {
        if currentPage + 1 < lessonsByPage.count {
            currentPage += 1
        }
    }
    
    func goToPreviousPage() {
        if currentPage > 0 {
            currentPage -= 1
        }
    }
}

// MARK: - Helpers
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
