import SwiftUI

extension Array where Element == any Coordinator {
    func getChild<T>(type: T.Type) -> T? {
        first(where: { router in
            router is T
        }) as? T
    }
}

extension Array where Element == UIViewController {
    func getController<T: View>(type: T.Type) -> UIHostingController<T>? {
        first { viewController in
            viewController is UIHostingController<T>
        } as? UIHostingController<T>
    }
}
