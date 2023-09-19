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
  func checkIsContactLastInTheList(_ contact: Contact) -> Bool

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
  func viewDidLoad() {}

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

  func contactsChanged() {
    view?.contactsChanged()
  }

}
