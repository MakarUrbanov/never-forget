//
// Created by makar on 11/19/22.
//

import UIKit

class BaseView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)

    setViews()
    setConstraints()
    setAppearanceConfiguration()
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

@objc
extension BaseView {

  func setViews() {}

  func setConstraints() {}

  func setAppearanceConfiguration() {}

}
