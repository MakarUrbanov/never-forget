//
// Created by makar on 11/22/22.
//

import UIKit

class BaseUITabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()

    setViews()
    setConstraints()
    setAppearanceConfiguration()
  }
}

@objc extension BaseUITabBarController {
  func setViews() {}

  func setConstraints() {}

  func setAppearanceConfiguration() {
    navigationController?.interactivePopGestureRecognizer?.delegate = nil
  }
}
