//
//  MainScreenNavigationController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 18.09.2023.
//

import UIKit

protocol IMainScreenNavigationController: UINavigationController {}

class MainScreenNavigationController: UINavigationController, IMainScreenNavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()

    initialize()
  }
}

// MARK: - Private methods
extension MainScreenNavigationController {

  private func initialize() {}

}
