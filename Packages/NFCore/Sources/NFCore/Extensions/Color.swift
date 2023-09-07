import SwiftUI

// MARK: - random
public extension Color {
  static var random: Color {
    Color(
      red: .random(in: 0...1),
      green: .random(in: 0...1),
      blue: .random(in: 0...1)
    )
  }
}

// MARK: - uiColor
public extension Color {
  var uiColor: UIColor {
    UIColor(self)
  }
}
