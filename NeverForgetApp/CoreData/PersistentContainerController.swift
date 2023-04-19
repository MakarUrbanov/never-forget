//
//  PersistentContainerController.swift
//  never-forget
//
//  Created by makar on 2/13/23.
//

import CoreData

class PersistentContainerController: ObservableObject {

  private let persistentContainer: NSPersistentCloudKitContainer
  var viewContext: NSManagedObjectContext
  var backgroundContext: NSManagedObjectContext

  init(storeName: String) {
    persistentContainer = PersistentContainerController.getInitialContainer(for: storeName)
    backgroundContext = persistentContainer.newBackgroundContext()
    viewContext = persistentContainer.viewContext
  }

  func exists<T>(_ model: NSManagedObject, in context: NSManagedObjectContext) -> T? {
    try? context.existingObject(with: model.objectID) as? T
  }

}

// MARK: - utils

extension PersistentContainerController {

  private func saveContextHandler(_ context: NSManagedObjectContext) {
    if context.hasChanges {
      context.perform {
        do {
          try context.save()
        } catch {
          let nserror = error as NSError
          fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
      }
    }
  }

  private static func getInitialContainer(for name: String) -> NSPersistentCloudKitContainer {
    let container = NSPersistentCloudKitContainer(name: name)

    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }

    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

    return container
  }

}
