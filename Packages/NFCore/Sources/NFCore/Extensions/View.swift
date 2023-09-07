import SwiftUI

// MARK: - hideKeyboard
public extension View {
  func hideKeyboard() {
    let resign = #selector(UIResponder.resignFirstResponder)
    UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
  }
}

// MARK: - if
public extension View {
  @ViewBuilder func `if`(_ condition: Bool, transform: @escaping (Self) -> some View) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}
