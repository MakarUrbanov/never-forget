//
//  CoreDataWrapper.swift
//  NeverForgetApp
//
//  Created by makar on 5/9/23.
//

import CoreData

final class CoreDataWrapper {
  static let shared = CoreDataWrapper()
  static let modelName = "NeverForgetModels"

  let persistentContainer: NSPersistentCloudKitContainer
  let viewContext: NSManagedObjectContext
  var backgroundContext: NSManagedObjectContext

  private init() {
    persistentContainer = CoreDataWrapper.getInitialContainer()
    viewContext = persistentContainer.viewContext

    backgroundContext = persistentContainer.newBackgroundContext()
    backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
  }

  func existingObject<T: NSManagedObject>(_ model: T, in context: NSManagedObjectContext) -> T? {
    try? context.existingObject(with: model.objectID) as? T
  }

  func newBackgroundQueueContext() -> NSManagedObjectContext {
    let context = persistentContainer.newBackgroundContext()
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return context
  }

  func newMainQueueContext() -> NSManagedObjectContext {
    let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    context.parent = viewContext
    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    return context
  }

}

// MARK: - Helpers

extension CoreDataWrapper {

  private static func getInitialContainer() -> NSPersistentCloudKitContainer {
    let container = NSPersistentCloudKitContainer(name: CoreDataWrapper.modelName)

    container.loadPersistentStores { _, error in
      if let error = error as NSError? {
        Logger.error(message: "Core Data loadPersistentStores Unresolved error", error, error.userInfo)
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }

    container.viewContext.automaticallyMergesChangesFromParent = true
    container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

    return container
  }


}

// MARK: - NSManagedObjectContext

extension NSManagedObjectContext {

  func saveChanges() {
    if hasChanges {
      do {
        try save()
      } catch {
        let nserror = error as NSError
        Logger.error(message: "Core Data unresolved error when saving context", nserror.localizedDescription, nserror)
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }

}
