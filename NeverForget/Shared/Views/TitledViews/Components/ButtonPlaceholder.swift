//
//  ButtonPlaceholder.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.10.2023.
//

import UIKit

class ButtonPlaceholder: TouchableButton {

  required init() {
    super.init(frame: .zero)

    var configuration = UIButton.Configuration.borderless()
    configuration.baseForegroundColor = UIColor(resource: .textLight100)
    configuration.buttonSize = .small
    configuration.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 0)
    self.configuration = configuration

    contentHorizontalAlignment = .leading
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
