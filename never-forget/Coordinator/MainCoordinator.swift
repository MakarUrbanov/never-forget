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
    tabBarController = MainTabController()
  }

  func start() {
    if let tabBarController = tabBarController as? MainTabController {
      tabBarController.configure()
    }
  }
}
