//
//  BaseUINavigationController.swift
//  never-forget
//
//  Created by makar on 2/23/23.
//

import UIKit

class BaseUINavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()

    setViews()
    setConstraints()
    setAppearanceConfiguration()
  }
}


@objc extension BaseUINavigationController {
  func setViews() {}

  func setConstraints() {}

  func setAppearanceConfiguration() {}
}
