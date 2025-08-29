import SwiftUI

/// Кастомный fullScreenPresenter с анимацией справа-налево
extension View {
    func presentFullScreen<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.background(
            FullScreenPresenter(isPresented: isPresented, content: content)
        )
    }
}

struct FullScreenPresenter<Content: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let content: () -> Content

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented, context.coordinator.host == nil {
            let hosting = UIHostingController(rootView: content())
            let nav = UINavigationController(rootViewController: hosting)
            nav.modalPresentationStyle = .fullScreen
            // Push-подобная анимация справа-налево
            uiViewController.present(nav, animated: true)
            context.coordinator.host = nav
        } else if !isPresented, let hosting = context.coordinator.host {
            hosting.dismiss(animated: true)
            context.coordinator.host = nil
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    class Coordinator { var host: UIViewController? }
}
