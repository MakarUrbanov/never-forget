//
//  ContactsScreenInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 18.09.2023
//

import Foundation
import UIKit

protocol IContactsScreenInteractor: AnyObject {
  var contacts: [Contact] { get }

  var contactsService: IContactsCoreDataService { get }
}

class ContactsScreenInteractor: IContactsScreenInteractor {

  weak var presenter: IContactsScreenPresenter?

  var contactsService: IContactsCoreDataService
  var contacts: [Contact] {
    contactsService.contacts
  }

  init(contactsService: IContactsCoreDataService) {
    self.contactsService = contactsService

    self.contactsService.addObserver(target: self, selector: #selector(contactsDidChange))

    contactsService.fetchContacts()
    contactsService.contacts.forEach { contactsService.context.delete($0) }

    let contactWithImage = Contact(context: self.contactsService.context)
    contactWithImage.firstName = "Makar"
    contactWithImage.lastName = "Urbanov"
    contactWithImage.photoData = UIImage(resource: .mock).pngData()
    let eventImagedContact = contactWithImage.createLinkedEvent(of: .systemGenerated)
    eventImagedContact.name = "Birthday"

    let contactNoImage = Contact(context: self.contactsService.context)
    contactNoImage.firstName = "Test"
    contactNoImage.lastName = "No image"
    let eventNoImageContact = contactNoImage.createLinkedEvent(of: .systemGenerated)
    eventNoImageContact.name = "Birthday"

    self.contactsService.context.saveChanges()
  }

  deinit {
    contactsService.removeObserver(from: self)
  }

}

private extension ContactsScreenInteractor {

  @objc
  private func contactsDidChange(_ notification: Notification) {
    print("mmk contacts changed")
    presenter?.contactsChanged()
  }

}
