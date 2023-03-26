//
// Created by makar on 11/19/22.
//

import UIKit

class BaseUIViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    setViews()
    setConstraints()
    setAppearanceConfiguration()
  }
}

@objc
extension BaseUIViewController {
  func setViews() {}

  func setConstraints() {}

  func setAppearanceConfiguration() {
    navigationController?.interactivePopGestureRecognizer?.delegate = nil
  }
}
