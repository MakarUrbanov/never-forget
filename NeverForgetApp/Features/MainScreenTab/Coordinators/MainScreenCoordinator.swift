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
    let view = PersonProfileView(person: person, goBack: {
      self.navigationController.navigate(step: .pop)
    })
    .environmentObject(self)
    .environment(\.managedObjectContext, PersistentContainerProvider.shared.viewContext)

    let addNewPersonView = UIHostingController(rootView: view)
    navigationController.navigate(step: .push(addNewPersonView))
  }

}

// MARK: - Utils

extension MainScreenCoordinator {

  private func getMainScreenView() -> UIViewController {
    let view = MainScreenView()
      .environmentObject(self)
      .environment(\.managedObjectContext, PersistentContainerProvider.shared.viewContext)

    let listTab = UIHostingController(rootView: view)
    return listTab
  }

}
