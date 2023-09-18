//
//  ContactsCoreDataService.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 18.09.2023.
//

import CoreData
import Foundation
import SwiftData
import UIKit

// MARK: - Protocol
protocol IContactsCoreDataService: IContactsService, IObservableObject {
  var context: NSManagedObjectContext { get }
  var fetchRequest: NSFetchRequest<Contact> { get }
  var fetchedResultController: NSFetchedResultsController<Contact> { get }

  init(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Contact>)

  func updateFetchRequest(_ fetchRequest: NSFetchRequest<Contact>)
}

// MARK: - EventsCoreDataService
class ContactsCoreDataService: NSObject, IContactsCoreDataService {

  // MARK: - Public properties
  var context: NSManagedObjectContext
  var fetchRequest: NSFetchRequest<Contact>
  var fetchedResultController: NSFetchedResultsController<Contact>
  var notificationName: NSNotification.Name = .init("EventsCoreDataDidChange")

  var contacts: [Contact] {
    fetchedResultController.fetchedObjects ?? []
  }

  // MARK: - Private properties
  private let notificationCenter = NotificationCenter.default

  // MARK: - Init
  required init(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Contact>) {
    self.context = context
    self.fetchRequest = fetchRequest
    fetchedResultController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil
    )

    super.init()

    fetchedResultController.delegate = self
  }

  // MARK: Public methods
  func updateFetchRequest(_ fetchRequest: NSFetchRequest<Contact>) {
    self.fetchRequest = fetchRequest
    fetchedResultController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil
    )
    fetchedResultController.delegate = self
  }

  @discardableResult
  func fetchContacts() -> [Contact] {
    do {
      try fetchedResultController.performFetch()
    } catch {
      Logger.error("Fetch contacts error", error.localizedDescription)
    }

    return contacts
  }

  func saveChanges() {
    context.saveChanges()
  }

  func revertChanges() {
    context.rollback()
  }

  func deleteContact(_ contact: Contact) {
    context.delete(contact)
  }

  func addObserver(target: Any, selector: Selector) {
    notificationCenter.addObserver(target, selector: selector, name: notificationName, object: nil)
  }

  func removeObserver(from target: Any) {
    notificationCenter.removeObserver(target, name: notificationName, object: nil)
  }

}

// MARK: - NSFetchedResultsControllerDelegate
extension ContactsCoreDataService: NSFetchedResultsControllerDelegate {

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    notificationCenter.post(name: notificationName, object: contacts)
  }

}
