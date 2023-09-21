//
//  ContactsScreenRouter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 18.09.2023
//

import CoreData

protocol IContactsScreenRouter: AnyObject {
  func presentContactProfile(_ contactId: NSManagedObjectID)
  func presentCreateNewContact()
}

class ContactsScreenRouter: IContactsScreenRouter {

  weak var viewController: IContactsScreenView?
  weak var coordinator: IContactsListCoordinator?

  init(coordinator: IContactsListCoordinator) {
    self.coordinator = coordinator
  }

  func presentContactProfile(_ contactId: NSManagedObjectID) {
    coordinator?.presentContactProfile(contactId: contactId)
  }

  func presentCreateNewContact() {
    coordinator?.presentCreateNewContact()
  }

}
