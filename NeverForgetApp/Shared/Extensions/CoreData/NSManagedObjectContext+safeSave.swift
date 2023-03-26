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
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }

}
