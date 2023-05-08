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
  var tabBarController: UITabBarController = BaseUITabBarController()

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

    mainScreenCoordinator.navigationController.tabBarItem = UITabBarItem(
      title: Localizable.Tabs.main.toString(),
      image: UIImage(systemName: "house"),
      selectedImage: UIImage(systemName: "house")
    )

    return mainScreenCoordinator
  }

  // MARK: initialize people list tab coordinator

  private func getPeopleListCoordinator() -> ContactsListCoordinator {
    let peopleListCoordinator = ContactsListCoordinator()
    peopleListCoordinator.start()

    peopleListCoordinator.navigationController.tabBarItem = UITabBarItem(
      title: Localizable.Tabs.list.toString(),
      image: UIImage(systemName: "person"),
      selectedImage: UIImage(systemName: "person")
    )

    return peopleListCoordinator
  }

  // MARK: initialize settings tab coordinator

  private func getSettingsTabCoordinator() -> SettingsTabCoordinator {
    let coordinator = SettingsTabCoordinator()
    coordinator.start()

    coordinator.navigationController.tabBarItem = UITabBarItem(
      title: Localizable.Tabs.settings.toString(),
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
