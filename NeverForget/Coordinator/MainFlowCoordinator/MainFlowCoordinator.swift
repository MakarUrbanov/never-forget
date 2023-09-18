//
//  MainFlowCoordinator.swift
//  never-forget
//
//  Created by makar on 2/6/23.
//

import NFLocalNotificationsManager
import SwiftUI

final class MainFlowCoordinator: TabCoordinator {
  var childCoordinators: [Coordinator] = []
  var tabBarController: UITabBarController = MainFlowTabBarController()

  init() {}

  func start() {
    let coordinators = initializeCoordinators()
    childCoordinators = coordinators

    let navigationControllers = coordinators.map(\.navigationController)
    tabBarController.setViewControllers(navigationControllers, animated: false)
  }

}

// MARK: - Deep Link
extension MainFlowCoordinator {

  func handleDeepLink(_ deepLink: NFLNDeepLink?) {
    guard let deepLink, let deepLinkComponents = deepLink.link.getDeepLinkComponents() else { return }

    switch deepLinkComponents.first {
      case .mainScreen:
        for coordinator in childCoordinators where (coordinator as? MainScreenCoordinator) != nil {
          if let index: Int = tabBarController.viewControllers?
            .firstIndex(where: { $0 === (coordinator as? MainScreenCoordinator)?.navigationController })
          {
            tabBarController.selectedIndex = index
          }

          let updatedDeepLink = deepLink.dropFirstLinkComponent()
          coordinator.handleDeepLink(updatedDeepLink)
        }

      default:
        break
    }
  }

}

// MARK: - Private methods
private extension MainFlowCoordinator {

  private func initializeCoordinators() -> [NavigationCoordinator] {
    let mainCoordinator = Self.getMainCoordinator()
    let contactsListCoordinator = Self.getContactsListCoordinator()
    let settingsCoordinator = Self.getSettingsTabCoordinator()

    // TODO: mmk temp order
    return [contactsListCoordinator, mainCoordinator, settingsCoordinator]
  }

}

// MARK: - Static
extension MainFlowCoordinator {

  private static func getMainCoordinator() -> MainScreenCoordinator {
    let mainScreenCoordinator = MainScreenCoordinator()
    mainScreenCoordinator.start()

    let tabBarItem = UITabBarItem(
      title: String(localized: "Main"),
      image: UIImage(systemName: "calendar"),
      selectedImage: UIImage(systemName: "calendar")
    )
    mainScreenCoordinator.navigationController.tabBarItem = tabBarItem

    return mainScreenCoordinator
  }

  private static func getContactsListCoordinator() -> ContactsListCoordinator {
    let contactsListCoordinator = ContactsListCoordinator()
    contactsListCoordinator.start()

    let tabBarItem = UITabBarItem(
      title: String(localized: "List"),
      image: UIImage(systemName: "person"),
      selectedImage: UIImage(systemName: "person")
    )
    contactsListCoordinator.navigationController.tabBarItem = tabBarItem

    return contactsListCoordinator
  }

  private static func getSettingsTabCoordinator() -> SettingsTabCoordinator {
    let coordinator = SettingsTabCoordinator()
    coordinator.start()

    let tabBarItem = UITabBarItem(
      title: String(localized: "Settings"),
      image: UIImage(systemName: "gearshape"),
      selectedImage: UIImage(systemName: "gearshape")
    )
    coordinator.navigationController.tabBarItem = tabBarItem

    return coordinator
  }

}
