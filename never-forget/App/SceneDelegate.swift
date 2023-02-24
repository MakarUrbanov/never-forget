//
//  SceneDelegate.swift
//  never-forget
//
//  Created by makar on 2/5/23.
//

import SwiftUI
import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var rootCoordinator: RootCoordinator?

  func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    window = UIWindow(windowScene: windowScene)

    let rootCoordinator = RootCoordinator(window: window ?? UIWindow())
    rootCoordinator.start()
    self.rootCoordinator = rootCoordinator

    window?.makeKeyAndVisible()
  }

  func sceneDidDisconnect(_: UIScene) {}

  func sceneDidBecomeActive(_: UIScene) {}

  func sceneWillResignActive(_: UIScene) {}

  func sceneWillEnterForeground(_: UIScene) {}

  func sceneDidEnterBackground(_: UIScene) {
    // TODO: save changes core data
  }
}
