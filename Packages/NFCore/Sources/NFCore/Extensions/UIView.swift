import UIKit

// MARK: - addView
public extension UIView {
  func addView(_ view: UIView) {
    view.translatesAutoresizingMaskIntoConstraints = false
    addSubview(view)
  }
}
