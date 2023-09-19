//
//  ContactsScreenInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 18.09.2023
//

import Foundation
import SwiftDate
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

    // ******** TODO: mmk delete
    let contactTodayEvent = Contact(context: self.contactsService.context)
    contactTodayEvent.firstName = "Event"
    contactTodayEvent.lastName = "Next year"
    let eventToday = contactTodayEvent.createLinkedEvent(of: .systemGenerated)
    eventToday.date = (eventToday.date - 10.days)

    let contactWithImage = Contact(context: self.contactsService.context)
    contactWithImage.firstName = "Makar"
    contactWithImage.lastName = "Urbanov"
    contactWithImage.photoData = UIImage(resource: .mock).pngData()
    let eventImagedContact = contactWithImage.createLinkedEvent(of: .systemGenerated)

    let contactNoImage = Contact(context: self.contactsService.context)
    contactNoImage.firstName = "Test"
    contactNoImage.lastName = "No image"
    let eventNoImageContact = contactNoImage.createLinkedEvent(of: .systemGenerated)
    eventNoImageContact.date = (eventNoImageContact.date + 10.days)

    self.contactsService.context.saveChanges()
    // ******** TODO: mmk delete
  }

  deinit {
    contactsService.removeObserver(from: self)
  }

}

private extension ContactsScreenInteractor {

  @objc
  private func contactsDidChange(_ notification: Notification) {
    presenter?.contactsChanged()
  }

}
