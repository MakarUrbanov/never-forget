//
//  ContactsListCoordinator.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import NFLocalNotificationsManager
import SwiftUI
import UIKit

final class ContactsListCoordinator: NavigationCoordinator, ObservableObject {
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController = .init()

  func start() {
    let peopleListScreen = getPeopleListScreenView()
    navigationController.setViewControllers([peopleListScreen], animated: false)
  }

}

// MARK: - Navigation
extension ContactsListCoordinator {

  private func getPeopleListScreenView() -> UIViewController {
    let view = UIViewController()

    return view
  }

}

// MARK: - Deep link
extension ContactsListCoordinator {

  func handleDeepLink(_ deepLink: NFLNDeepLink?) {} // TODO: rework

}
