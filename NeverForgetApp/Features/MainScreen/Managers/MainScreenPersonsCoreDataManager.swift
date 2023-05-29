//
//  MainScreenPersonsCoreDataManager.swift
//  NeverForgetApp
//
//  Created by makar on 5/10/23.
//

import CoreData
import UIKit

protocol MainScreenPersonsCoreDataManagerDelegate: AnyObject {
  func personsChanged(_ persons: [Person])
}

final class MainScreenPersonsCoreDataManager: NSObject {

  private let context: NSManagedObjectContext
  private let fetchedResultController: NSFetchedResultsController<Person>

  weak var delegate: MainScreenPersonsCoreDataManagerDelegate? { didSet { delegate?.personsChanged(persons) } }

  var persons: [Person] {
    fetchedResultController.fetchedObjects ?? []
  }

  init(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<Person>) {
    self.context = context

    fetchedResultController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: context,
      sectionNameKeyPath: nil,
      cacheName: nil
    )

    super.init()

    fetchedResultController.delegate = self

    do {
      try fetchedResultController.performFetch()
      delegate?.personsChanged(persons)
    } catch {
      Logger.error(message: "Unable to perform fetch:", error)
    }
  }
}

extension MainScreenPersonsCoreDataManager: NSFetchedResultsControllerDelegate {

  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    delegate?.personsChanged(persons)
  }

}
