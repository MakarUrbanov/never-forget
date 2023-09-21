//
//  ContactsScreenPresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 18.09.2023
//

import Foundation

protocol IContactsScreenPresenter: AnyObject {
  func viewDidLoad()
  func getContactsCount() -> Int
  func getContact(at indexPath: IndexPath) -> Contact
  func getContacts() -> [Contact]
  func checkIsContactLastInTheList(_ contact: Contact) -> Bool
  func setSortingByNearestEvents()
  func setSortingAlphabetically()
  func openContactProfile(_ contact: Contact)
  func presentCreateNewProfile()
  func contactsChanged()
}

class ContactsScreenPresenter: IContactsScreenPresenter {

  weak var view: IContactsScreenView?
  var router: IContactsScreenRouter
  var interactor: IContactsScreenInteractor

  init(interactor: IContactsScreenInteractor, router: IContactsScreenRouter) {
    self.interactor = interactor
    self.router = router
  }

  // MARK: - Public methods
  func viewDidLoad() {
    interactor.initialFetchContacts()
  }

  func getContacts() -> [Contact] {
    interactor.contacts
  }

  func getContactsCount() -> Int {
    interactor.contacts.count
  }

  func getContact(at indexPath: IndexPath) -> Contact {
    interactor.contacts[indexPath.item]
  }

  func checkIsContactLastInTheList(_ contact: Contact) -> Bool {
    guard let lastContact = interactor.contacts.last else {
      return false
    }

    return contact.id == lastContact.id
  }

  func setSortingByNearestEvents() {
    interactor.setSortingByNearestEvents()
    interactor.fetchContacts()
    contactsChanged()
  }

  func setSortingAlphabetically() {
    interactor.setSortingAlphabetically()
    interactor.fetchContacts()
    contactsChanged()
  }

  func openContactProfile(_ contact: Contact) {
    let contactId = contact.objectID
    router.presentContactProfile(contactId)
  }

  func presentCreateNewProfile() {
    router.presentCreateNewContact()
  }

  func contactsChanged() {
    view?.contactsChanged()
  }

}
