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
    .init(keyPath: \Contact.nearestEventDate, ascending: true),
  ])

  private static let fetchRequestSortAlphabetically = Contact.fetchRequestWithSorting(descriptors: [
    .init(keyPath: \Contact.lastName, ascending: true),
    .init(keyPath: \Contact.firstName, ascending: true),
  ])

}
