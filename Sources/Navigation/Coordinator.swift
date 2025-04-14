import UIKit

@MainActor
public protocol Coordinator: AnyObject, ObservableObject {
    // MARK: Associated types
    associatedtype Input
    associatedtype Output

    // MARK: Variables
    var childCoordinators: [any Coordinator] { get set }

    // MARK: Constants
    var input: Input? { get }
    var navigationController: UINavigationController { get }
    var showCloseButton: Bool { get }
    var coordinatorDidFinish: ((Coordinator, Output?) -> Void)? { get }

    // MARK: Init
    init(navigationController: UINavigationController, input: Input?, showCloseButton: Bool, coordinatorDidFinish: ((Coordinator, Output?) -> Void)?)
}

// MARK: - Lifecycle management
extension Coordinator {
    /// Adds a child coordinator to the parent
    public func addChildCoordinator(childCoordinator: any Coordinator) {
        print("adding child coordinator: \(childCoordinator)")
        childCoordinators.append(childCoordinator)
        print("\(String(describing: self)) childrens are now: \(childCoordinators.map { String(describing: $0) }.joined(separator: ", "))")
    }

    /// Adds a child coordinator to the parent and removes the same type in case it already exists
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

    /// Remove a child coordinator from the parent
    public func removeChildCoordinator<T: Coordinator>(ofType type: T.Type) {
        guard let childCoordinator = childCoordinators.getChild(type: type) else { return }
        removeChildCoordinator(childCoordinator: childCoordinator)
    }
}

// MARK: - Buttons
extension Coordinator {
    /// Setups back button for bridging between SwiftUI and UIKit navigation stack
    public func setupBackButton() {
        guard showCloseButton == false else {
            return
        }

        guard let coordinatorDidFinish else {
            navigationController.topViewController?.navigationItem.leftBarButtonItem = nil
            return
        }

        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 8

        let backButton = UIButton(configuration: configuration, primaryAction: UIAction { [weak self] _ in
            guard let self else { return }
            coordinatorDidFinish(self, nil)
        })
        let backButtonImage = UIImage(systemName: "chevron.backward")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold))?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        backButton.setImage(backButtonImage, for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)

        navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

    /// Setups close button for modal presentation
    public func setupCloseButton() {
        guard let coordinatorDidFinish else {
            navigationController.topViewController?.navigationItem.leftBarButtonItem = nil
            return
        }

        guard showCloseButton else {
            setupBackButton()
            return
        }

        navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { [weak self] _ in
            guard let self else { return }
            coordinatorDidFinish(self, nil)
        })
    }
}
