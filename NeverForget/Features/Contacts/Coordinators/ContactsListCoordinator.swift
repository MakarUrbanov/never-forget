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

protocol IContactsListCoordinator: NavigationCoordinator {
  func presentContactProfile(contactId: NSManagedObjectID)
  func presentCreateNewContact()
}

final class ContactsListCoordinator: NavigationCoordinator, ObservableObject, IContactsListCoordinator {

  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController = .init()

  func start() {
    let peopleListScreen = getContactsListView()
    navigationController.setViewControllers([peopleListScreen], animated: false)
  }

}

// MARK: - Navigate to the Contact profile screen
extension ContactsListCoordinator {

  static let contactProfileContext = CoreDataStack.shared.backgroundContext

  private func presentContactProfileCoordinator(_ contact: Contact) {
    let coordinator = ContactProfileCoordinator()
    coordinator.start()
    coordinator.delegate = self
    childCoordinators.append(coordinator)
    coordinator.showContactProfile(for: contact)

    navigationController.navigate(step: .present(coordinator.navigationController, .formSheet), animated: true)
  }

  func presentContactProfile(contactId: NSManagedObjectID) {
    let context = Self.contactProfileContext

    guard let contact = try? context.existingObject(with: contactId) as? Contact else {
      // TODO: mmk invoke error modal
      fatalError()
    }

    presentContactProfileCoordinator(contact)
  }

  func presentCreateNewContact() {
    let context = Self.contactProfileContext
    let newContact = Contact(context: context)

    presentContactProfileCoordinator(newContact)
  }

}

// MARK: - IContactProfileCoordinatorDelegate
extension ContactsListCoordinator: IContactProfileCoordinatorDelegate {

  func closeProfileCoordinator(_ coordinator: IContactProfileCoordinator) {
    navigationController.navigate(step: .dismiss)
    childCoordinators.removeAll(where: { $0 === coordinator })
  }

}

// MARK: - Private methods
private extension ContactsListCoordinator {

  private func getContactsListView() -> IContactsScreenView {
    let context = CoreDataStack.shared.viewContext // TODO: mmk edit
    let fetchRequest = Contact.fetchRequestWithSorting(descriptors: [
      .init(keyPath: \Contact.nearestEventDate, ascending: true)
    ])
    let contactsService = ContactsCoreDataService(context: context, fetchRequest: fetchRequest)
    let view = ContactsScreenModuleBuilder.build(coordinator: self, contactsService: contactsService)

    return view
  }

}

// MARK: - Deep link
extension ContactsListCoordinator {

  func handleDeepLink(_ deepLink: NFLNDeepLink?) {} // TODO: rework

}
