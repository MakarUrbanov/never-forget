//
//  AppDelegate.swift
//  never-forget
//
//  Created by makar on 2/5/23.
//

import CoreData
import IQKeyboardManagerSwift
import NFCore
import UIKit

@main final class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    IQKeyboardManager.shared.enable = true
    IQKeyboardManager.shared.toolbarTintColor = UIColor(resource: .main100)
//    IQKeyboardManager.shared.enableAutoToolbar = false
    IQKeyboardManager.shared.keyboardDistanceFromTextField = 40

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
}
