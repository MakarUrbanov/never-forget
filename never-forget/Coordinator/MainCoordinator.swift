//
//  MainCoordinator.swift
//  never-forget
//
//  Created by makar on 2/6/23.
//

import SwiftUI

class MainCoordinator: TabCoordinator {
  var childCoordinators: [Coordinator] = []
  var tabBarController: UITabBarController

  init() {
    tabBarController = MainTabBarController()
  }

  func start() {
    if let tabBarController = tabBarController as? MainTabBarController {
      tabBarController.configure()
    }
  }
}
