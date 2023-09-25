//
//  ContactProfileCoordinator.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 23.09.2023.
//

import NFLocalNotificationsManager
import UIKit

protocol IContactProfileCoordinatorDelegate: AnyObject {
  func closeProfileCoordinator(_ coordinator: IContactProfileCoordinator)
}

protocol IContactProfileCoordinator: NavigationCoordinator {
  func presentContactProfile(for contact: Contact)
  func presentCreateContact()
  func closeContactCoordinator()
}

class ContactProfileCoordinator: NavigationCoordinator, IContactProfileCoordinator {

  var navigationController: UINavigationController = .init()
  var childCoordinators: [Coordinator] = []

  weak var delegate: IContactProfileCoordinatorDelegate?

  func start() {
    setupNavigationController()
  }

  func presentContactProfile(for contact: Contact) {
    let viewController = ContactProfileModuleBuilder.buildEditContact(contact: contact, coordinator: self)
    navigationController.setViewControllers([viewController], animated: false)
  }

  func presentCreateContact() {
    let contact = Contact(context: CoreDataStack.shared.backgroundContext)
    let viewController = ContactProfileModuleBuilder.buildCreateContact(contact: contact, coordinator: self)
    navigationController.setViewControllers([viewController], animated: false)
  }

  func closeContactCoordinator() {
    delegate?.closeProfileCoordinator(self)
  }

}

// MARK: - Private methods
private extension ContactProfileCoordinator {

  private func setupNavigationController() {
    navigationController.isModalInPresentation = true
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
