//
//  CoreDataStack.swift
//  NeverForgetApp
//
//  Created by makar on 5/9/23.
//

import CoreData

// MARK: - Protocol
protocol ICoreDataStack: AnyObject {
  static var shared: Self { get }
  static var modelName: String { get }

  var persistentContainer: NSPersistentCloudKitContainer { get }
  var viewContext: NSManagedObjectContext { get }
  var backgroundContext: NSManagedObjectContext { get }
}

// MARK: - CoreDataWrapper
final class CoreDataStack: ICoreDataStack {
  static let shared = CoreDataStack()
  static let modelName = "NeverForgetModels"

  let persistentContainer: NSPersistentCloudKitContainer
  let viewContext: NSManagedObjectContext
  let backgroundContext: NSManagedObjectContext

  private init() {
    persistentContainer = CoreDataStack.getInitialContainer()
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

// MARK: - Static
extension CoreDataStack {

  private static func getInitialContainer() -> NSPersistentCloudKitContainer {
    let container = NSPersistentCloudKitContainer(name: CoreDataStack.modelName)

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
