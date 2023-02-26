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

}

// MARK: - Static

extension PersistentContainerController {

  private func saveContextHandler(_ context: NSManagedObjectContext) {
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
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

// MARK: - save context

extension PersistentContainerController {

  func saveAllContexts() {
    saveContextHandler(viewContext)
    saveContextHandler(backgroundContext)
  }

  func saveContext() {
    saveContextHandler(viewContext)
  }

  func saveBackgroundContext() {
    saveContextHandler(backgroundContext)
  }

}

// MARK: - reset context

extension PersistentContainerController {


  func resetAllContexts() {
    viewContext.reset()
    backgroundContext.reset()
  }

  func resetContext() {
    viewContext.reset()
  }

  func resetBackgroundContext() {
    backgroundContext.reset()
  }

}
