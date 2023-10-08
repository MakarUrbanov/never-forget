//
//  UIButton+makePrimaryButton.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 08.10.2023.
//

import UIKit

extension UIButton {

  func makePrimaryButton() {
    titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    titleLabel?.textColor = UIColor(resource: .textLight100)
    setTitleColor(UIColor(resource: .textLight100).withAlphaComponent(0.6), for: .highlighted)
    backgroundColor = UIColor(resource: .main100)
    layer.cornerRadius = 8
  }

}
