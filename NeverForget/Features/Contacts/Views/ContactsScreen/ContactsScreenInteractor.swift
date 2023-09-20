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

  func setSortingByNearestEvents()
  func setSortingAlphabetically()
  func initialFetchContacts()
  func fetchContacts()
}

class ContactsScreenInteractor: IContactsScreenInteractor {

  // MARK: - Public properties
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
    contactNextYearEvent.firstName = "Makar"
    contactNextYearEvent.lastName = "Urbanov"
    contactNextYearEvent.photoData = UIImage(resource: .mock).pngData()
    contactNextYearEvent.createLinkedEvent(of: .systemGenerated)
      .setOriginDate(DateInRegion("2000-09-14T14:00:00+00:00")!.dateAt(.startOfDay).date)
//    contactNextYearEvent.createLinkedEvent(of: .systemGenerated)
//      .setOriginDate(.now.dateByAdding(-300, .day).date)

    let contactWithImage = Contact(context: self.contactsService.context)
    contactWithImage.firstName = "Denis"
    contactWithImage.lastName = "Kalugin"
    contactWithImage.createLinkedEvent(of: .systemGenerated)
      .setOriginDate(DateInRegion("2000-04-24T14:00:00+00:00")!.dateAt(.startOfDay).date)
//    contactWithImage.createLinkedEvent(of: .userCreated)

    let contactNoImage = Contact(context: self.contactsService.context)
    contactNoImage.firstName = "Boris"
    contactNoImage.lastName = "ТудейБездыч"
    contactNoImage.createLinkedEvent(of: .systemGenerated)
      .setOriginDate(.now.dateAt(.startOfDay))

    self.contactsService.context.saveChanges()
    // ******** TODO: mmk delete
  }

  func initialFetchContacts() {
    contactsService.fetchContacts()
    presenter?.contactsChanged()
  }

  func setSortingByNearestEvents() {
    contactsService.updateFetchRequest(Self.fetchRequestSortByNearestEvents)
  }

  func setSortingAlphabetically() {
    contactsService.updateFetchRequest(Self.fetchRequestSortAlphabetically)
  }

  func fetchContacts() {
    contactsService.fetchContacts()
  }

  deinit {
    contactsService.removeObserver(from: self)
  }

}

// MARK: - Private methods
private extension ContactsScreenInteractor {

  @objc
  private func contactsDidChange(_ notification: Notification) {
    presenter?.contactsChanged()
  }

}

// MARK: - Static
extension ContactsScreenInteractor {

  private static let fetchRequestSortByNearestEvents = Contact.fetchRequestWithSorting(descriptors: [
    .init(keyPath: \Contact.nearestEventDate, ascending: true)
  ])

  private static let fetchRequestSortAlphabetically = Contact.fetchRequestWithSorting(descriptors: [
    .init(keyPath: \Contact.lastName, ascending: true),
    .init(keyPath: \Contact.firstName, ascending: true)
  ])

}
