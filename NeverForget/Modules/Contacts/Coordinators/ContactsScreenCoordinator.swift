//
//  ContactsScreenCoordinator.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import CoreData
import NFLocalNotificationsManager
import SwiftUI
import UIKit

protocol IContactsScreenCoordinator: NavigationCoordinator {
  func presentContactProfile(contactId: NSManagedObjectID)
  func presentCreateNewContact()
  func removeChildCoordinator(_ coordinator: Coordinator)
}

final class ContactsScreenCoordinator: NavigationCoordinator, ObservableObject, IContactsScreenCoordinator {

  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let peopleListScreen = getContactsListView()
    navigationController.setViewControllers([peopleListScreen], animated: false)
  }

  func removeChildCoordinator(_ coordinator: Coordinator) {
    childCoordinators.removeAll(where: { $0 === coordinator })
  }

}

// MARK: - Navigate to the Contact profile screen
extension ContactsScreenCoordinator {

  static let contactProfileContext = CoreDataStack.shared.backgroundContext

  private func initializeContactProfileCoordinator() -> IContactProfileCoordinator {
    let coordinator = ContactProfileCoordinator(navigationController: .init())
    coordinator.parentCoordinator = self
    childCoordinators.append(coordinator)
    coordinator.start()

    return coordinator
  }

  func presentContactProfile(contactId: NSManagedObjectID) {
    let context = Self.contactProfileContext

    guard let contact = try? context.existingObject(with: contactId) as? Contact else {
      // TODO: mmk invoke error modal
      fatalError()
    }

    let contactProfileCoordinator = initializeContactProfileCoordinator()
    contactProfileCoordinator.setContactProfileController(for: contact)

    contactProfileCoordinator.navigationController.modalPresentationStyle = .formSheet
    navigationController.present(contactProfileCoordinator.navigationController, animated: true)
  }

  func presentCreateNewContact() {
    let contactProfileCoordinator = initializeContactProfileCoordinator()
    contactProfileCoordinator.setCreateContactProfileController()

    contactProfileCoordinator.navigationController.modalPresentationStyle = .formSheet
    navigationController.present(contactProfileCoordinator.navigationController, animated: true)
  }

}

// MARK: - Private methods
private extension ContactsScreenCoordinator {

  private func getContactsListView() -> IContactsScreenView {
    let context = CoreDataStack.shared.viewContext // TODO: mmk edit
    let fetchRequest = Contact.fetchRequestWithSorting(descriptors: [
      .init(keyPath: \Contact.nearestEventDate, ascending: true),
    ])
    let contactsService = ContactsCoreDataService(context: context, fetchRequest: fetchRequest)
    let view = ContactsScreenModuleBuilder.build(coordinator: self, contactsService: contactsService)

    return view
  }

}

// MARK: - Deep link
extension ContactsScreenCoordinator {

  func handleDeepLink(_ deepLink: NFLNDeepLink?) {} // TODO: rework

}
