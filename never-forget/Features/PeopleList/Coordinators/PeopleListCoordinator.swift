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
    let createNewPersonView = UIHostingController(rootView: CreateNewPersonView(goBack: {
      self.navigationController.navigate(step: .dismiss)
    }))

    navigationController.navigate(step: .present(createNewPersonView, .pageSheet))
  }

  func openPersonProfile(person: Person) {
    let addNewPersonView = UIHostingController(rootView: PersonProfileView(person: person, goBack: {
      self.navigationController.navigate(step: .pop)
    }))

    navigationController.navigate(step: .push(addNewPersonView))
  }

}

// MARK: - utils

extension PeopleListCoordinator {

  private func getPeopleListScreenView() -> UIViewController {
    let listTab = UIHostingController(
      rootView: PeopleListScreenView()
        .environmentObject(self)
        .environment(\.managedObjectContext, PersistentContainerProvider.shared.viewContext)
    )
    return listTab
  }

}
