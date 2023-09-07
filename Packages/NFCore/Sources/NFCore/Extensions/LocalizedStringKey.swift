import SwiftUI

// MARK: - toString
public extension LocalizedStringKey {
  func toString(locale: Locale = .current) -> String {
    return .localizedString(for: toStringKey, locale: locale)
  }
}

// MARK: - toStringKey
public extension LocalizedStringKey {
  var toStringKey: String {
    Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String ?? ""
  }
}
