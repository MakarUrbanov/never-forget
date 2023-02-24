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

  init(window: UIWindow) {
    self.window = window
  }

  func start() {
    setRootCoordinator()
  }

}

extension RootCoordinator {

  private func setRootCoordinator() {
    let mainCoordinator = MainFlowCoordinator()
    mainCoordinator.start()
    window.rootViewController = mainCoordinator.tabBarController
    childCoordinators.append(mainCoordinator)
  }

}
