import SwiftUI

public struct NavigationControllerView<C: Coordinator>: View {
    private let appCoordinator: any Coordinator
    private let input: C.Input?
    private let coordinatorDidFinish: ((any Coordinator, C.Output?) -> Void)?
    private let showCloseButton: Bool

    public init(appCoordinator: any Coordinator, input: C.Input? = nil, showCloseButton: Bool = false, coordinatorDidFinish: ((any Coordinator, C.Output?) -> Void)?) {
        self.appCoordinator = appCoordinator
        self.input = input
        self.coordinatorDidFinish = coordinatorDidFinish
        self.showCloseButton = showCloseButton
    }

    public var body: some View {
        _NavigationControllerView<C>(appCoordinator: appCoordinator, input: input, showCloseButton: showCloseButton, coordinatorDidFinish: coordinatorDidFinish)
            .ignoresSafeArea()
            .toolbar(.hidden, for: .navigationBar)
    }
}

private struct _NavigationControllerView<C: Coordinator>: UIViewControllerRepresentable {
    let appCoordinator: any Coordinator
    let input: C.Input?
    let showCloseButton: Bool
    let coordinatorDidFinish: ((any Coordinator, C.Output?) -> Void)?

    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        let coordinator = C(navigationController: navigationController, input: input, showCloseButton: showCloseButton, coordinatorDidFinish: coordinatorDidFinish)
        appCoordinator.addChildCoordinatorAndRemoveIfSameTypeExists(childCoordinator: coordinator)
        return navigationController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) { }
}
