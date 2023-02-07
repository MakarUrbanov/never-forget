//
//  Coordinator.swift
//  never-forget
//
//  Created by makar on 2/6/23.
//

import UIKit

protocol Coordinator: AnyObject {
  var childCoordinators: [Coordinator] { get set }
  func start()
}
