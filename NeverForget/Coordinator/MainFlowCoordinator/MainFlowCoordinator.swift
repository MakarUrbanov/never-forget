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

  init() {

  }

  func start() {
    let mainCoordinator = getMainCoordinator()
    let peopleListCoordinator = getPeopleListCoordinator()
    let settingsCoordinator = getSettingsTabCoordinator()

    childCoordinators = [mainCoordinator, peopleListCoordinator, settingsCoordinator]
    tabBarController.setViewControllers(
      [
        mainCoordinator.navigationController,
        peopleListCoordinator.navigationController,
        settingsCoordinator.navigationController
      ],
      animated: false
    )
  }

}

// MARK: - Navigation
extension MainFlowCoordinator {

  // MARK: initialize main tab coordinator
  private func getMainCoordinator() -> MainScreenCoordinator {
    let mainScreenCoordinator = MainScreenCoordinator()
    mainScreenCoordinator.start()

    let icon = UIImage(systemName: "calendar")
    let tabBarItem = UITabBarItem(
      title: String(localized: "Main"),
      image: icon,
      selectedImage: icon?.withTintColor(UIColor(resource: .main100), renderingMode: .alwaysOriginal)
    )
    mainScreenCoordinator.navigationController.tabBarItem = tabBarItem

    return mainScreenCoordinator
  }

  private func getPeopleListCoordinator() -> ContactsListCoordinator {
    let peopleListCoordinator = ContactsListCoordinator()
    peopleListCoordinator.start()

    peopleListCoordinator.navigationController.tabBarItem = UITabBarItem(
      title: String(localized: "List"),
      image: UIImage(systemName: "person"),
      selectedImage: UIImage(systemName: "person")
    )

    return peopleListCoordinator
  }

  private func getSettingsTabCoordinator() -> SettingsTabCoordinator {
    let coordinator = SettingsTabCoordinator()
    coordinator.start()

    coordinator.navigationController.tabBarItem = UITabBarItem(
      title: String(localized: "Settings"),
      image: UIImage(systemName: "gearshape"),
      selectedImage: UIImage(systemName: "gearshape")
    )

    return coordinator
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
