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

  func presentAddNewPersonView() {
    let addNewPersonView = UIHostingController(rootView: AddNewPersonView())
    navigationController.navigate(step: .present(addNewPersonView, .pageSheet))
  }

}


extension PeopleListCoordinator {

  private func getPeopleListScreenView() -> UIViewController {
    let listTab = UIHostingController(rootView: PeopleListScreenView().environmentObject(self))
    return listTab
  }

}
