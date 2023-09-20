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

  func initialFetchContacts()
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

    // ******** TODO: mmk delete
    contactsService.fetchContacts()
    contactsService.contacts.forEach { contactsService.context.delete($0) }

    let contactNextYearEvent = Contact(context: self.contactsService.context)
    contactNextYearEvent.firstName = "User1"
    contactNextYearEvent.lastName = "first"
    contactNextYearEvent.createLinkedEvent(of: .systemGenerated)
      .setOriginDate(.now.dateByAdding(300, .day).date)
    contactNextYearEvent.createLinkedEvent(of: .systemGenerated)
      .setOriginDate(.now.dateByAdding(-300, .day).date)

    let contactWithImage = Contact(context: self.contactsService.context)
    contactWithImage.firstName = "Makar"
    contactWithImage.lastName = "Urbanov"
    contactWithImage.photoData = UIImage(resource: .mock).pngData()
    contactWithImage.createLinkedEvent(of: .systemGenerated)
      .setOriginDate(Date.nowAt(.startOfDay))
    contactWithImage.createLinkedEvent(of: .userCreated)
      .setOriginDate(DateInRegion().convertTo(region: .UTC).date + 100.days)

    let contactNoImage = Contact(context: self.contactsService.context)
    contactNoImage.firstName = "User2"
    contactNoImage.lastName = "Second"
    contactNoImage.createLinkedEvent(of: .systemGenerated)
      .setOriginDate(.now.dateByAdding(10, .day).date)
    contactNoImage.createLinkedEvent(of: .systemGenerated)
      .setOriginDate(.now.dateByAdding(-364, .day).date)

    self.contactsService.context.saveChanges()
    // ******** TODO: mmk delete
  }

  func initialFetchContacts() {
    contactsService.fetchContacts()
    presenter?.contactsChanged()
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
