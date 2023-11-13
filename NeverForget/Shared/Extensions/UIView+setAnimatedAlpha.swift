//
//  UIView+setAnimatedAlpha.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 13.11.2023.
//

import UIKit

extension UIView {
  func setAnimatedAlpha(_ alpha: CGFloat) {
    UIView.animate(withDuration: 0.15, delay: 0, options: .allowUserInteraction) {
      self.alpha = alpha
    }
  }
}
