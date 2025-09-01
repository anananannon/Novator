import SwiftUI

struct LessonsView: View {
    @StateObject var profileVM: UserProfileViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(TaskManager.lessons) { lesson in
                    NavigationLink(destination: TaskDetailView(profile: profileVM, lessonName: lesson.lesson)) {
                        HStack {
                            Text(lesson.lesson)
                            Spacer()
                            Text("\(lesson.tasks.filter { profileVM.profile.completedTasks.contains($0.id) }.count)/\(lesson.tasks.count)")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Уроки")
        }
    }
}
