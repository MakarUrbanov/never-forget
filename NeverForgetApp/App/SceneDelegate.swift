//
//  SceneDelegate.swift
//  never-forget
//
//  Created by makar on 2/5/23.
//

import NFLocalNotificationsManager
import SwiftUI
import UIKit
import UserNotifications

final class SceneDelegate: UIResponder, UIWindowSceneDelegate, UNUserNotificationCenterDelegate {

  var window: UIWindow?
  var rootCoordinator: RootCoordinator?
  let notificationCenter = UNUserNotificationCenter.current()

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)

    let rootCoordinator = RootCoordinator(window: window ?? UIWindow())
    rootCoordinator.start()
    self.rootCoordinator = rootCoordinator

    notificationCenter.delegate = self
    window?.makeKeyAndVisible()
  }

  func sceneDidDisconnect(_: UIScene) {}

  func sceneDidBecomeActive(_: UIScene) {}

  func sceneWillResignActive(_: UIScene) {}

  func sceneWillEnterForeground(_: UIScene) {}

  func sceneDidEnterBackground(_: UIScene) {
    PersistentContainerProvider.shared.viewContext.saveSafely()
  }

  // MARK: - Notifications

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo

    if let deepLinkData = userInfo["deepLink"] as? Data {
      if let decodedDeepLink = try? JSONDecoder().decode(NFLNDeepLink.self, from: deepLinkData) {
        rootCoordinator?.handleDeepLink(decodedDeepLink)
      }
    }

    completionHandler()
  }

}
