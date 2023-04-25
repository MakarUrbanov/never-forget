//
//  PeopleListCoordinator.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import SwiftUI
import UIKit

final class PeopleListCoordinator: NavigationCoordinator, ObservableObject {
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController = BaseUINavigationController()

  func start() {
    let peopleListScreen = getPeopleListScreenView()
    navigationController.setViewControllers([peopleListScreen], animated: false)
  }

}


// MARK: - navigation

extension PeopleListCoordinator {

  func presentCreateNewPersonView() {
    let view = CreateNewPersonView(goBack: { self.navigationController.navigate(step: .dismiss) })
      .environmentObject(self)
      .environment(\.managedObjectContext, PersistentContainerProvider.shared.viewContext)

    let createNewPersonView = UIHostingController(rootView: view)

    navigationController.navigate(step: .present(createNewPersonView, .pageSheet))
  }

  func openPersonProfile(person: Person) {
    let view = PersonProfileView(person: person, goBack: { self.navigationController.navigate(step: .pop) })
      .environmentObject(self)
      .environment(\.managedObjectContext, PersistentContainerProvider.shared.viewContext)

    let personProfileView = UIHostingController(rootView: view)

    navigationController.navigate(step: .push(personProfileView))
  }

}

// MARK: - utils

extension PeopleListCoordinator {

  private func getPeopleListScreenView() -> UIViewController {
    let view = PeopleListScreenView()
      .environmentObject(self)
      .environment(\.managedObjectContext, PersistentContainerProvider.shared.viewContext)

    let listTab = UIHostingController(rootView: view)
    return listTab
  }

}
