//
//  Coordinator.swift
//  never-forget
//
//  Created by makar on 2/6/23.
//

import NFLocalNotificationsManager
import UIKit

protocol Coordinator: AnyObject {
  var childCoordinators: [Coordinator] { get set }
  func start()

  func removeChildCoordinator(_ coordinator: Coordinator)
  func handleDeepLink(_ deepLink: NFLNDeepLink?)
}
