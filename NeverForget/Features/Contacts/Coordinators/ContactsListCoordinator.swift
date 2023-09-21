//
//  ContactsListCoordinator.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import CoreData
import NFLocalNotificationsManager
import SwiftUI
import UIKit

final class ContactsListCoordinator: NavigationCoordinator, ObservableObject {
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController = .init()

  func start() {
    let peopleListScreen = getContactsListView()
    navigationController.setViewControllers([peopleListScreen], animated: false)
  }

}

// MARK: - Navigation
extension ContactsListCoordinator {

  private func getContactsListView() -> IContactsScreenView {
    let context = CoreDataStack.shared.viewContext // TODO: mmk edit
    let fetchRequest = Contact.fetchRequestWithSorting(descriptors: [
      .init(keyPath: \Contact.nearestEventDate, ascending: true)
    ])
    let contactsService = ContactsCoreDataService(context: context, fetchRequest: fetchRequest)
    let view = ContactsScreenModuleBuilder.build(contactsService: contactsService)

    return view
  }

}

// MARK: - Deep link
extension ContactsListCoordinator {

  func handleDeepLink(_ deepLink: NFLNDeepLink?) {} // TODO: rework

}
