//
//  FlowCoordinator.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import Foundation
import UIKit

final class RootCoordinator: Coordinator {
  let window: UIWindow
  var childCoordinators: [Coordinator] = []
  let rootNavigationController = BaseUINavigationController()

  init(window: UIWindow) {
    self.window = window

    configureRootNavigationController()
    connectAlertManager()
  }

  func start() {
    setRootCoordinator()
  }

}

extension RootCoordinator {

  private func configureRootNavigationController() {
    rootNavigationController.isNavigationBarHidden = true
  }

  private func connectAlertManager() {
    AlertManager.shared.rootNavigationController = rootNavigationController
  }

  private func setRootCoordinator() {
    let mainCoordinator = MainFlowCoordinator()
    mainCoordinator.start()

    rootNavigationController.setViewControllers([mainCoordinator.tabBarController], animated: false)
    window.rootViewController = rootNavigationController
    childCoordinators.append(mainCoordinator)
  }

}
