//
//  RootCoordinator.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import Foundation
import NFLocalNotificationsManager
import SwiftUI
import UIKit

final class RootCoordinator: Coordinator {

  let window: UIWindow
  var childCoordinators: [Coordinator] = []
  let rootNavigationController = UINavigationController()

  init(window: UIWindow) {
    self.window = window

    configureRootNavigationController()
    connectAlertManager()
    initializeNotifications()
  }

  func start() {
    setRootCoordinator()
  }

  func removeChildCoordinator(_ coordinator: Coordinator) {
    childCoordinators.removeAll(where: { $0 === coordinator })
  }

}

// MARK: - Navigation

extension RootCoordinator {

  private func configureRootNavigationController() {
    rootNavigationController.isNavigationBarHidden = true
  }

  private func connectAlertManager() {
    AppAlertManager.shared.rootNavigationController = rootNavigationController
  }

  private func setRootCoordinator() {
    let mainCoordinator = MainFlowCoordinator(tabBarController: MainFlowTabBarController())
    mainCoordinator.start()

    rootNavigationController.setViewControllers([mainCoordinator.tabBarController], animated: false)
    window.rootViewController = rootNavigationController
    childCoordinators.append(mainCoordinator)
  }

}

// MARK: - Notifications

extension RootCoordinator {

  func initializeNotifications() {
    Task {
      await LocalNotificationsManager.shared.requestPermission()
    }

    LocalNotificationsManager.shared.registerCategories()
  }

}

// MARK: - Deep link

extension RootCoordinator {

  func handleDeepLink(_ deepLink: NFLNDeepLink?) {
    guard let deepLink, let deepLinkComponents = deepLink.link.getDeepLinkComponents() else { return }

    switch deepLinkComponents.first {
      case .mainFlow:
        for coordinator in childCoordinators where (coordinator as? MainFlowCoordinator) != nil {
          let updatedDeepLink = deepLink.dropFirstLinkComponent()
          coordinator.handleDeepLink(updatedDeepLink)
        }

      default:
        break
    }
  }

}
