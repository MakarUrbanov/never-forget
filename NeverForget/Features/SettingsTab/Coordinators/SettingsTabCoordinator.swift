//
//  SettingsTabCoordinator.swift
//  NeverForgetApp
//
//  Created by makar on 4/20/23.
//

import NFLocalNotificationsManager
import SwiftUI
import UIKit

class SettingsTabCoordinator: NavigationCoordinator, ObservableObject {

  var navigationController: UINavigationController
  var childCoordinators: [Coordinator] = []

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let settingsView = getConfiguredSettingsView()
    navigationController.pushViewController(settingsView, animated: false)
  }

  func removeChildCoordinator(_ coordinator: Coordinator) {
    childCoordinators.removeAll(where: { $0 === coordinator })
  }

}

// MARK: - Utils

extension SettingsTabCoordinator {

  private func getConfiguredSettingsView() -> UIHostingController<some View> {
    let view = SettingsView()
      .environmentObject(self)
      .environment(\.managedObjectContext, CoreDataStack.shared.viewContext)

    return UIHostingController(rootView: view)
  }

}

// MARK: - Deep link

extension SettingsTabCoordinator {

  func handleDeepLink(_ deepLink: NFLNDeepLink?) {} // TODO: rework

}
