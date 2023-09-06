import UIKit

public enum NavigationSteps {
  case push(UIViewController)
  case pop
  case present(UIViewController, UIModalPresentationStyle)
  case dismiss
}

// MARK: - navigate
public extension UINavigationController {
  func navigate(step: NavigationSteps, animated: Bool = true, completion: @escaping () -> Void = {}) {
    switch step {
      case .push(let controller):
        pushViewController(controller, animated: animated)
        completion()

      case .pop:
        popViewController(animated: animated)
        completion()

      case .present(let controller, let style):
        controller.modalPresentationStyle = style

        if let presentedViewController {
          presentedViewController.present(controller, animated: animated, completion: completion)
        } else {
          topViewController?.present(controller, animated: animated, completion: completion)
        }

      case .dismiss:
        if let presentedViewController {
          presentedViewController.dismiss(animated: animated, completion: completion)
        } else {
          topViewController?.dismiss(animated: animated, completion: completion)
        }
    }
  }
}
