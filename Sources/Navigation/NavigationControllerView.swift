import SwiftUI

public struct NavigationControllerView<C: Coordinator, Output>: View {
    private let appCoordinator: any Coordinator
    private let input: C.Input?
    private let coordinatorDidFinish: ((CoordinatorOutput<Output>) -> Void)?
    private let showCloseButton: Bool

    public init(appCoordinator: any Coordinator, input: C.Input? = nil, showCloseButton: Bool = false, coordinatorDidFinish: ((CoordinatorOutput<Output>) -> Void)? = nil) {
        self.appCoordinator = appCoordinator
        self.input = input
        self.coordinatorDidFinish = coordinatorDidFinish
        self.showCloseButton = showCloseButton
    }

    public var body: some View {
        _NavigationControllerView<C, Output>(appCoordinator: appCoordinator, input: input, showCloseButton: showCloseButton, coordinatorDidFinish: coordinatorDidFinish)
            .ignoresSafeArea()
            .toolbar(.hidden, for: .navigationBar)
    }
}

private struct _NavigationControllerView<C: Coordinator, Output>: UIViewControllerRepresentable {
    let appCoordinator: any Coordinator
    let input: C.Input?
    let showCloseButton: Bool
    let coordinatorDidFinish: ((CoordinatorOutput<Output>) -> Void)?

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        let coordinator = C(navigationController: navigationController, input: input)
        /*
        if let coordinatorWithDidFinish = coordinator as? any CoordinatorWithDidFinish {
            coordinatorWithDidFinish.coordinatorDidFinish = coordinatorDidFinish
            coordinatorWithDidFinish.showCloseButton = showCloseButton
        }
        */
        appCoordinator.addChildCoordinatorAndRemoveIfSameTypeExists(childCoordinator: coordinator)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) { }
}
