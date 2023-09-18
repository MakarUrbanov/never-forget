//
//  EventsCoreDataService.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 11.09.2023.
//

import CoreData
import Foundation
import SwiftData
import UIKit

// MARK: - Protocol
protocol IEventsCoreDataService: IEventsService, IObservableObject {
  var context: NSManagedObjectContext { get }
  var fetchRequest: NSFetchRequest<Event> { get }
  var fetchedResultController: NSFetchedResultsController<Event> { get }

  init(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Event>)

  func updateFetchRequest(_ fetchRequest: NSFetchRequest<Event>)
}

// MARK: - EventsCoreDataService
class EventsCoreDataService: NSObject, IEventsCoreDataService {

  // MARK: - Public properties
  var context: NSManagedObjectContext
  var fetchRequest: NSFetchRequest<Event>
  var fetchedResultController: NSFetchedResultsController<Event>
  var notificationName: NSNotification.Name = .init("EventsCoreDataDidChange")

  var events: [Event] {
    fetchedResultController.fetchedObjects ?? []
  }

  // MARK: - Private properties
  private let notificationCenter = NotificationCenter.default

  // MARK: - Init
  required init(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Event>) {
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
  func updateFetchRequest(_ fetchRequest: NSFetchRequest<Event>) {
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
  func fetchEvents() -> [Event] {
    do {
      try fetchedResultController.performFetch()
    } catch {
      Logger.error("Fetch events error", error.localizedDescription)
    }

    return events
  }

  func saveChanges() {
    context.saveChanges()
  }

  func revertChanges() {
    context.rollback()
  }

  func deleteEvent(_ event: Event) {
    context.delete(event)
  }

  func addObserver(target: Any, selector: Selector) {
    notificationCenter.addObserver(target, selector: selector, name: notificationName, object: nil)
  }

  func removeObserver(from target: Any) {
    notificationCenter.removeObserver(target, name: notificationName, object: nil)
  }

}

// MARK: - NSFetchedResultsControllerDelegate
extension EventsCoreDataService: NSFetchedResultsControllerDelegate {

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    print("mmk controller changed")
    notificationCenter.post(name: notificationName, object: events)
  }

}
