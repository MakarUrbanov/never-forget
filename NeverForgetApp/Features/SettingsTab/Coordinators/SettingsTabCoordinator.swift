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
  var navigationController: UINavigationController = BaseUINavigationController()
  var childCoordinators: [Coordinator] = []

  func start() {
    let settingsView = getConfiguredSettingsView()
    navigationController.pushViewController(settingsView, animated: false)
  }

}

// MARK: - Utils

extension SettingsTabCoordinator {

  private func getConfiguredSettingsView() -> UIHostingController<some View> {
    let view = SettingsView()
      .environmentObject(self)
      .environment(\.managedObjectContext, CoreDataWrapper.shared.viewContext)

    return UIHostingController(rootView: view)
  }

}

// MARK: - Deep link

extension SettingsTabCoordinator {

  func handleDeepLink(_ deepLink: NFLNDeepLink?) {} // TODO: rework

}
