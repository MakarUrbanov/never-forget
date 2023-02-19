//
//  addView.swift
//  never-forget
//
//  Created by makar on 2/7/23.
//

import UIKit

extension UIView {
  func setupView(_ view: UIView) {
    addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
  }
}
