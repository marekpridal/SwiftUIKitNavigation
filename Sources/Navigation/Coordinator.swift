import UIKit

@MainActor
public protocol Coordinator: AnyObject, ObservableObject {
    var childCoordinators: [any Coordinator] { get set }

    init(navigationController: UINavigationController)
}

extension Coordinator {
    /// Add a child coordinator to the parent
    private func addChildCoordinator(childCoordinator: any Coordinator) {
        print("adding child coordinator: \(childCoordinator)")
        childCoordinators.append(childCoordinator)
        print("\(String(describing: self)) childrens are now: \(childCoordinators.map { String(describing: $0) }.joined(separator: ", "))")
    }

    public func addChildCoordinatorAndRemoveIfSameTypeExists(childCoordinator: any Coordinator) {
        let toRemove = childCoordinators.first { coord -> Bool in
            type(of: coord) == type(of: childCoordinator)
        }
        if let toRemove = toRemove {
            removeChildCoordinator(childCoordinator: toRemove)
        }

        addChildCoordinator(childCoordinator: childCoordinator)
    }

    /// Remove a child coordinator from the parent
    public func removeChildCoordinator(childCoordinator: any Coordinator) {
        print("removing child coordinator: \(childCoordinator)")
        childCoordinators = childCoordinators.filter { $0 !== childCoordinator }
        print("\(String(describing: self)) childrens are now: \(childCoordinators.map { String(describing: $0) }.joined(separator: ", "))")
    }

    public func removeChildCoordinator<T: Coordinator>(ofType type: T.Type) {
        guard let childCoordinator = childCoordinators.getChild(type: type) else { return }
        removeChildCoordinator(childCoordinator: childCoordinator)
    }
}
