//
//  PersistentContainerController.swift
//  never-forget
//
//  Created by makar on 2/13/23.
//

import CoreData

class PersistentContainerController: ObservableObject {

  private let persistentContainer: NSPersistentCloudKitContainer

  var viewContext: NSManagedObjectContext {
    persistentContainer.viewContext
  }

  var backgroundContext: NSManagedObjectContext {
    persistentContainer.newBackgroundContext()
  }

  init(storeName: String) {
    persistentContainer = PersistentContainerController.getInitialContainer(for: storeName)
  }

  func saveContext() {
    if viewContext.hasChanges {
      do {
        try viewContext.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }

}

// MARK: - Static

extension PersistentContainerController {

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
