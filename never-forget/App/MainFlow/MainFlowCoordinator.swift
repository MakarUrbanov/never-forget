//
//  MainFlowCoordinator.swift
//  never-forget
//
//  Created by makar on 2/6/23.
//

import SwiftUI

final class MainFlowCoordinator: TabCoordinator {
  var childCoordinators: [Coordinator] = []
  var tabBarController: UITabBarController = BaseUITabBarController()

  func start() {
    let mainCoordinator = getMainCoordinator()
    let peopleListCoordinator = getPeopleListCoordinator()

    childCoordinators += [mainCoordinator, peopleListCoordinator]
    tabBarController
      .setViewControllers(
        [mainCoordinator.navigationController, peopleListCoordinator.navigationController],
        animated: false
      )

//    tabBarController.selectedIndex = 1 // TODO: delete
  }

}

// MARK: - initialize main coordinator

extension MainFlowCoordinator {

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

}

// MARK: - initialize people list coordinator

extension MainFlowCoordinator {

  private func getPeopleListCoordinator() -> PeopleListCoordinator {
    let peopleListCoordinator = PeopleListCoordinator()
    peopleListCoordinator.start()
    peopleListCoordinator.navigationController.tabBarItem = UITabBarItem(
      title: Localizable.Tabs.list.toString(),
      image: UIImage(systemName: "person"),
      selectedImage: UIImage(systemName: "person")
    )

    return peopleListCoordinator
  }

}
