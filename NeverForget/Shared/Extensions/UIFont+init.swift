//
//  UIFont+init.swift
//  NeverForgetApp
//
//  Created by makar on 5/16/23.
//

import UIKit

extension UIFont {

  // swiftlint:disable:next cyclomatic_complexity
  static func systemFont(_ style: UIFont.TextStyle, _ fontWeight: UIFont.Weight) -> UIFont {
    switch style {
      case .largeTitle:
        return systemFont(ofSize: 26, weight: fontWeight)
      case .title1:
        return systemFont(ofSize: 24, weight: fontWeight)
      case .title2:
        return systemFont(ofSize: 22, weight: fontWeight)
      case .title3:
        return systemFont(ofSize: 20, weight: fontWeight)
      case .headline:
        return systemFont(ofSize: 18, weight: fontWeight)
      case .subheadline:
        return systemFont(ofSize: 16, weight: fontWeight)
      case .body:
        return systemFont(ofSize: 14, weight: fontWeight)
      case .callout:
        return systemFont(ofSize: 12, weight: fontWeight)
      case .footnote:
        return systemFont(ofSize: 10, weight: fontWeight)
      case .caption1:
        return systemFont(ofSize: 8, weight: fontWeight)
      case .caption2:
        return systemFont(ofSize: 6, weight: fontWeight)
      default:
        return systemFont(ofSize: 14, weight: fontWeight)
    }
  }

}
