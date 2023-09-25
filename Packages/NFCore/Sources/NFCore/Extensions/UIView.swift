import UIKit

// MARK: - setCircleRadius
public extension UIView {

  func setCircleRadius() {
    let radius = bounds.width / 2
    layer.cornerRadius = radius
  }

}
