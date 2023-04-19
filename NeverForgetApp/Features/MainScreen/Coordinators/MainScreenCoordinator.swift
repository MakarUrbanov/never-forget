//
//  MainScreenCoordinator.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import SwiftUI
import UIKit

final class MainScreenCoordinator: NavigationCoordinator, ObservableObject {

  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController = BaseUINavigationController()

  func start() {
    let mainScreen = getMainScreenView()
    navigationController.setViewControllers([mainScreen], animated: false)
  }

}

// MARK: - Navigations

extension MainScreenCoordinator {

  func goToPersonProfile(person: Person) {
    let addNewPersonView = UIHostingController(rootView: PersonProfileView(person: person, goBack: {
      self.navigationController.navigate(step: .pop)
    }))

    navigationController.navigate(step: .push(addNewPersonView))
  }

}

// MARK: - Utils

extension MainScreenCoordinator {

  private func getMainScreenView() -> UIViewController {
    let listTab = UIHostingController(
      rootView:
      MainScreenView()
        .environmentObject(self)
        .environment(\.managedObjectContext, PersistentContainerProvider.shared.viewContext)
    )
    return listTab
  }

}
