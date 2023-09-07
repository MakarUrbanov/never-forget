import UIKit

// MARK: - resizeImage
public extension UIImage {
  func resizeImage(maxSize: CGSize) -> UIImage {
    let widthRatio = maxSize.width / size.width
    let heightRatio = maxSize.height / size.height
    let scale = min(widthRatio, heightRatio)

    let newWidth = size.width * scale
    let newHeight = size.height * scale

    let newSize = CGSize(width: newWidth, height: newHeight)

    let renderer = UIGraphicsImageRenderer(size: newSize)
    let newImage = renderer.image { _ in
      self.draw(in: CGRect(origin: .zero, size: newSize))
    }

    return newImage
  }
}
