//
//  NavigationCoordinator.swift
//  never-forget
//
//  Created by makar on 2/6/23.
//

import UIKit

protocol NavigationCoordinator: Coordinator {
  var navigationController: UINavigationController { get }
}
