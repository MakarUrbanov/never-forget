//
//  AppDelegate.swift
//  never-forget
//
//  Created by makar on 2/5/23.
//

import CoreData
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(
    _: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options _: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {}

  // MARK: - Core Data stack

  lazy var persistentContainer: NSPersistentCloudKitContainer = {
    let container = NSPersistentCloudKitContainer(name: "never_forget")
    container.loadPersistentStores(completionHandler: { _, error in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })

    return container
  }()

  // MARK: - Core Data Saving support

  func saveContext() {
    let context = persistentContainer.viewContext

    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }

}
