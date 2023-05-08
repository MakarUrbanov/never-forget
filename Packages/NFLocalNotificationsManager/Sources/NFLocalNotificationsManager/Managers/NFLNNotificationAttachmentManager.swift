//
//  NotificationAttachmentManager.swift
//
//
//  Created by makar on 4/30/23.
//

import UIKit

class NFLNNotificationAttachmentManager {

  static let shared = NFLNNotificationAttachmentManager()

  private let fileManager = FileManager.default

  private init() {}

  func saveImage(_ imageData: Data) throws -> URL {
    guard let resizedImageData = resizeImage(imageData) else {
      NFLNLogger.error(message: "couldn't compress the image", imageData)
      throw SaveImageError.imageCompressionError
    }

    guard let url = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else {
      NFLNLogger.error(message: "has no image directory url")
      throw SaveImageError.fileManagerDirectoryUrlError
    }

    let uniqueImageName = UUID().uuidString
    let imageUrl = url.appending(path: uniqueImageName).appendingPathExtension("png")

    do {
      try resizedImageData.write(to: imageUrl)
    } catch {
      NFLNLogger.error(message: "Error writing image data to file", error)
      throw SaveImageError.resizingImageError
    }

    return imageUrl
  }

  func deleteExistingImage(at url: URL) {
    if fileManager.fileExists(atPath: url.path) {
      do {
        try fileManager.removeItem(at: url)
      } catch {
        NFLNLogger.error(message: "Error deleting image file", url, error)
      }
    } else {
      NFLNLogger.warn(message: "Can't find image with url:", url)
    }
  }

}

extension NFLNNotificationAttachmentManager {

  private func resizeImage(
    _ image: Data,
    size: CGSize = .init(width: 300, height: 300)
  ) -> Data? {
    guard let image = UIImage(data: image) else { return nil }

    let originalSize = image.size
    let aspectRatio = min(size.width / originalSize.width, size.height / originalSize.height)
    let newSize = CGSize(width: originalSize.width * aspectRatio, height: originalSize.height * aspectRatio)

    let renderer = UIGraphicsImageRenderer(size: newSize)
    renderer.image { _ in
      image.draw(in: CGRect(origin: .zero, size: newSize))
    }

    let imageData = renderer.pngData { _ in
      image.draw(in: CGRect(origin: .zero, size: newSize))
    }

    return imageData
  }

}

extension NFLNNotificationAttachmentManager {

  private enum SaveImageError: Error {
    case imageCompressionError
    case fileManagerDirectoryUrlError
    case resizingImageError
  }

}
