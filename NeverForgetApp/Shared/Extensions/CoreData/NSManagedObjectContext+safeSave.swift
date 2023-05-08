//
//  NSManagedObjectContext+safeSave.swift
//  never-forget
//
//  Created by makar on 2/26/23.
//

import CoreData

extension NSManagedObjectContext {

  func saveSafely() {
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
