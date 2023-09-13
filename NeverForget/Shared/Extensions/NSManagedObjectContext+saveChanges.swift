//
//  NSManagedObjectContext+saveChanges.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 13.09.2023.
//

import CoreData

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
