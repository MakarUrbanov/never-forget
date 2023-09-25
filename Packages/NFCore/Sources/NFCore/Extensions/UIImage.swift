import UIKit

// MARK: - resized
public extension UIImage {

  /// Compress the image\
  /// Resource-intensive method, better to run on a background thread
  /// - Parameter maxSize: maximal size of resulted image. if the original size is less than the maxSize,
  /// then compression will not occur
  /// - Returns: A compressed image, or the same image if maxSize larger than the original size
  func resized(maxSize: CGSize) -> UIImage {
    let widthRatio = maxSize.width / size.width
    let heightRatio = maxSize.height / size.height
    let scale = min(widthRatio, heightRatio)

    if scale >= 1 {
      return self
    }

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
