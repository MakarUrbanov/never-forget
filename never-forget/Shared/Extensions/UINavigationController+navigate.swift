//
//  UINavigationController+navigate.swift
//  never-forget
//
//  Created by makar on 2/23/23.
//

import UIKit

extension UINavigationController {

  func navigate(step: NavigationSteps, animated: Bool = true) {
    switch step {
      case let .push(controller):
        pushViewController(controller, animated: animated)

      case .pop:
        popViewController(animated: animated)

      case let .present(controller, style):
        controller.modalPresentationStyle = style

        if let presentedViewController = presentedViewController {
          presentedViewController.present(controller, animated: animated, completion: nil)
        } else {
          topViewController?.present(controller,
                                     animated: animated,
                                     completion: nil)
        }

      case .dismiss:
        if let presentedViewController = presentedViewController {
          presentedViewController.dismiss(animated: animated, completion: nil)
        } else {
          topViewController?.dismiss(animated: animated, completion: nil)
        }
    }
  }

}
