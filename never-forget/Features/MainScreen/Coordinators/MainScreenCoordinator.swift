//
//  MainScreenCoordinator.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import SwiftUI
import UIKit

final class MainScreenCoordinator: NavigationCoordinator {

  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController = BaseUINavigationController()

  func start() {
    let mainScreen = getMainScreenView()
    navigationController.setViewControllers([mainScreen], animated: false)
  }

}

extension MainScreenCoordinator {

  private func getMainScreenView() -> UIViewController {
    let listTab = UIHostingController(rootView: MainScreenView())
    return listTab
  }

}
