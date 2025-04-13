import UIKit

@MainActor
public protocol CoordinatorWithDidFinish: Coordinator {
    var coordinatorDidFinish: ((any CoordinatorWithDidFinish) -> Void)? { get set }
    var navigationController: UINavigationController { get }
    var showCloseButton: Bool { get set }

    func setupBackButton()
}

extension CoordinatorWithDidFinish {
    public func setupBackButton() {
        guard let coordinatorDidFinish else {
            navigationController.topViewController?.navigationItem.leftBarButtonItem = nil
            return
        }

        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 8

        let backButton = UIButton(configuration: configuration, primaryAction: UIAction { [weak self] _ in
            guard let self else { return }
            coordinatorDidFinish(self)
        })
        let backButtonImage = UIImage(systemName: "chevron.backward")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(weight: .semibold))?.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
        backButton.setImage(backButtonImage, for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)

        navigationController.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }

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
            self.coordinatorDidFinish?(self)
        })
    }
}
