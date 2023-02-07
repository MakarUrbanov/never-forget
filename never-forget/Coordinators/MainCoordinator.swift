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

  init(_ tabBarController: UITabBarController) {
    self.tabBarController = tabBarController
  }

  func start() {
    // TODO: mmk add localization
    let mainTab = UIHostingController(rootView: MainTab())
    mainTab.tabBarItem = UITabBarItem(title: "Main",
                                      image: UIImage(systemName: "house"),
                                      selectedImage: UIImage(systemName: "house"))

    let listTab = UIHostingController(rootView: ListTab())
    listTab.tabBarItem = UITabBarItem(title: "List",
                                      image: UIImage(systemName: "person"),
                                      selectedImage: UIImage(systemName: "person"))

    tabBarController.setViewControllers([mainTab, listTab], animated: false)
  }

}
