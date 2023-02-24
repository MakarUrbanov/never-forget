//
//  PeopleListCoordinator.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import SwiftUI
import UIKit

final class PeopleListCoordinator: NavigationCoordinator {

  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController = BaseUINavigationController()

  func start() {
    let peopleListScreen = getPeopleListScreenView()
    navigationController.setViewControllers([peopleListScreen], animated: false)
  }

}


extension PeopleListCoordinator {

  private func getPeopleListScreenView() -> UIViewController {
    let listTab = UIHostingController(rootView: PeopleListScreenView())
    return listTab
  }

}
