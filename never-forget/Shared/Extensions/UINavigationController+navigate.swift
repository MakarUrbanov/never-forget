//
//  UINavigationController+navigate.swift
//  never-forget
//
//  Created by makar on 2/23/23.
//

import UIKit

extension UINavigationController {

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

        if let presentedViewController = presentedViewController {
          presentedViewController.present(controller, animated: animated, completion: completion)
        } else {
          topViewController?.present(controller, animated: animated, completion: completion)
        }

      case .dismiss:
        if let presentedViewController = presentedViewController {
          presentedViewController.dismiss(animated: animated, completion: completion)
        } else {
          topViewController?.dismiss(animated: animated, completion: completion)
        }
    }
  }

}
