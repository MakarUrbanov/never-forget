import UIKit

// MARK: - setCircleRadius
public extension UIView {

  func setCircleRadius() {
    let radius = bounds.width / 2
    layer.cornerRadius = radius
  }

}

public extension UIView {
  struct DashedBorder {
    var color: UIColor
    var lineWidth: CGFloat
    var cornerRadius: CGFloat
    var dashPattern: [NSNumber]

    public init(color: UIColor, lineWidth: CGFloat, cornerRadius: CGFloat, dashPattern: [NSNumber]) {
      self.color = color
      self.lineWidth = lineWidth
      self.cornerRadius = cornerRadius
      self.dashPattern = dashPattern
    }
  }

  @discardableResult
  func setAndGetDashedBorderLayer(settings: DashedBorder) -> CAShapeLayer {
    let shapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height / 2)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = settings.color.cgColor
    shapeLayer.lineWidth = settings.lineWidth
    shapeLayer.lineJoin = .round
    shapeLayer.lineDashPattern = settings.dashPattern
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: settings.cornerRadius).cgPath

    self.layer.addSublayer(shapeLayer)

    return shapeLayer
  }
}
