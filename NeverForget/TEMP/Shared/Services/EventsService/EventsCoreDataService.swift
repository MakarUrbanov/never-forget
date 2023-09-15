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

// MARK: - Delegate
protocol IEventsCoreDataServiceDelegate: AnyObject {
  func eventsChanged(_ events: [Event])
}

// MARK: - Protocol
protocol IEventsCoreDataService: IEventsService {
  var context: NSManagedObjectContext { get }
  var fetchRequest: NSFetchRequest<Event> { get }
  var fetchedResultController: NSFetchedResultsController<Event> { get }

  var delegate: IEventsCoreDataServiceDelegate? { get set }

  init(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Event>)

  func updateFetchRequest(_ fetchRequest: NSFetchRequest<Event>)
}

// MARK: - EventsCoreDataService
class EventsCoreDataService: NSObject, IEventsCoreDataService {

  var context: NSManagedObjectContext
  var fetchRequest: NSFetchRequest<Event>
  var fetchedResultController: NSFetchedResultsController<Event>

  var events: [Event] {
    fetchedResultController.fetchedObjects ?? []
  }

  weak var delegate: IEventsCoreDataServiceDelegate?

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

  func saveEvent(_ event: Event) {
    context.saveChanges()
  }

  func deleteEvent(_ event: Event) {
    context.delete(event)
  }

}

// MARK: - NSFetchedResultsControllerDelegate
extension EventsCoreDataService: NSFetchedResultsControllerDelegate {

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    delegate?.eventsChanged(events)
  }

}
