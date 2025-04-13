import SwiftUI

public struct NavigationControllerView<C: Coordinator>: View {
    private let appCoordinator: any Coordinator
    private let coordinatorDidFinish: ((any CoordinatorWithDidFinish) -> Void)?
    private let showCloseButton: Bool

    public init(appCoordinator: any Coordinator, showCloseButton: Bool = false, coordinatorDidFinish: ((any CoordinatorWithDidFinish) -> Void)? = nil) {
        self.appCoordinator = appCoordinator
        self.coordinatorDidFinish = coordinatorDidFinish
        self.showCloseButton = showCloseButton
    }

    public var body: some View {
        _NavigationControllerView<C>(appCoordinator: appCoordinator, showCloseButton: showCloseButton, coordinatorDidFinish: coordinatorDidFinish)
            .ignoresSafeArea()
            .toolbar(.hidden, for: .navigationBar)
    }
}

private struct _NavigationControllerView<C: Coordinator>: UIViewControllerRepresentable {
    let appCoordinator: any Coordinator
    let showCloseButton: Bool
    let coordinatorDidFinish: ((any CoordinatorWithDidFinish) -> Void)?

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        let coordinator = C(navigationController: navigationController)
        if let coordinatorWithDidFinish = coordinator as? any CoordinatorWithDidFinish {
            coordinatorWithDidFinish.coordinatorDidFinish = coordinatorDidFinish
            coordinatorWithDidFinish.showCloseButton = showCloseButton
        }
        appCoordinator.addChildCoordinatorAndRemoveIfSameTypeExists(childCoordinator: coordinator)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) { }
}
