//
//  lighter+darker.swift
//  never-forget
//
//  Created by makar on 2/22/23.
//

import UIKit

extension UIColor {

  func lighter(by percentage: Int) -> UIColor {
    return adjust(by: abs(CGFloat(100 + percentage))) ?? self
  }

  func darker(by percentage: Int) -> UIColor {
    return adjust(by: abs(CGFloat(100 + -percentage))) ?? self
  }

}

extension UIColor {

  private func adjust(by percentage: CGFloat) -> UIColor? {
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
    if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
      return UIColor(red: min(red + percentage / 100, 1.0),
                     green: min(green + percentage / 100, 1.0),
                     blue: min(blue + percentage / 100, 1.0),
                     alpha: alpha)
    } else {
      return nil
    }
  }

}
