//
//  ContactProfileCoordinator.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 23.09.2023.
//

import NFLocalNotificationsManager
import UIKit

protocol IContactProfileCoordinator: NavigationCoordinator {
  var parentCoordinator: IContactsScreenCoordinator? { get set }

  func setContactProfileController(for contact: Contact)
  func setCreateContactProfileController()

  func goToEventScreen(of event: Event)

  func close()
}

class ContactProfileCoordinator: NavigationCoordinator, IContactProfileCoordinator {

  var navigationController: UINavigationController
  var childCoordinators: [Coordinator] = []

  weak var parentCoordinator: IContactsScreenCoordinator?

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    setupNavigationController()
  }

  func setContactProfileController(for contact: Contact) {
    let viewController = ContactProfileModuleBuilder.buildEditContact(contact: contact, coordinator: self)
    navigationController.viewControllers = [viewController]
  }

  func setCreateContactProfileController() {
    let contact = Contact(context: CoreDataStack.shared.backgroundContext)
    contact.createLinkedBirthdayEvent()

    let viewController = ContactProfileModuleBuilder.buildCreateContact(contact: contact, coordinator: self)
    navigationController.viewControllers = [viewController]
  }

  func goToEventScreen(of event: Event) {
    let eventViewController = EventScreenModuleBuilder.build()
    navigationController.pushViewController(eventViewController, animated: true)
  }

  func close() {
    navigationController.dismiss(animated: true) { [weak self] in
      guard let self else { return }

      self.parentCoordinator?.removeChildCoordinator(self)
    }
  }

  func removeChildCoordinator(_ coordinator: Coordinator) {
    childCoordinators.removeAll(where: { $0 === coordinator })
  }

}

// MARK: - Private methods
private extension ContactProfileCoordinator {

  private func setupNavigationController() {
    navigationController.navigationBar.titleTextAttributes = [
      .font: UIFont.systemFont(ofSize: 16, weight: .bold),
      .foregroundColor: UIColor(resource: .textLight100)
    ]
  }

}

// MARK: - Deep link
extension ContactProfileCoordinator {

  func handleDeepLink(_ deepLink: NFLNDeepLink?) {}

}
