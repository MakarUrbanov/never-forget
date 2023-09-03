//
//  Theme.swift
//  NeverForgetApp
//
//  Created by makar on 5/12/23.
//

import SwiftUI
import UIKit

// MARK: - UIKit Colors

// swiftlint:disable force_unwrapping
extension UIColor {

  enum Theme {
    static let accentColor = UIColor(named: "accentColor")!

    static let background = UIColor(named: "background")!
    static let background2 = UIColor(named: "background2")!
    static let background3 = UIColor(named: "background3")!

    static let text = UIColor(named: "text")!
    static let text2 = UIColor(named: "text2")!
    static let text3 = UIColor(named: "text3")!
    static let text4 = UIColor(named: "text4")!

    static let error = UIColor(named: "error")!
  }

}

// swiftlint:enable force_unwrapping

// MARK: - SwiftUI Colors

extension Color {

  enum Theme {
    static let accentColor = Color(UIColor.Theme.accentColor)

    static let background = Color(UIColor.Theme.background)
    static let background2 = Color(UIColor.Theme.background2)
    static let background3 = Color(UIColor.Theme.background3)

    static let text = Color(UIColor.Theme.text)
    static let text2 = Color(UIColor.Theme.text2)
    static let text3 = Color(UIColor.Theme.text3)
    static let text4 = Color(UIColor.Theme.text4)

    static let error = Color(UIColor.Theme.error)
  }

}
