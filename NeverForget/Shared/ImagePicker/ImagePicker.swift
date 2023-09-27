//
//  ImagePicker.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 25.09.2023.
//

import PhotosUI
import UIKit

// MARK: - Delegate
protocol IImagePickerDelegate: AnyObject {
  func didSelectImages(_ images: [UIImage])
}

// MARK: - Protocol
protocol IImagePicker: AnyObject {
  var pickerViewController: PHPickerViewController { get }
  var delegate: IImagePickerDelegate? { get set }

  init(configuration: PHPickerConfiguration)
}

// MARK: - ImagePicker
class ImagePicker: IImagePicker {

  let pickerViewController: PHPickerViewController

  weak var delegate: IImagePickerDelegate?

  required init(configuration: PHPickerConfiguration) {
    pickerViewController = PHPickerViewController(configuration: configuration)
    pickerViewController.delegate = self
  }

}

// MARK: - Private methods
extension ImagePicker {

  private func deselectSelectedAssets(pickerResult: [PHPickerResult]) {
    let selectedAssetsIdentifiers = pickerResult.compactMap(\.assetIdentifier)

    if !selectedAssetsIdentifiers.isEmpty {
      pickerViewController.deselectAssets(withIdentifiers: selectedAssetsIdentifiers)
    }
  }

}

// MARK: - PHPickerViewControllerDelegate
extension ImagePicker: PHPickerViewControllerDelegate {

  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    var images: [UIImage?] = []

    let group = DispatchGroup()

    for result in results {
      group.enter()
      guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else {
        Logger.error(message: "Image picker error. Failed to load UIImage")
        group.leave()
        return
      }

      result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
        if let error {
          Logger.error(message: "Image picker error", error)
          group.leave()
          return
        }

        DispatchQueue.main.async {
          images.append(image as? UIImage)
          group.leave()
        }
      }
    }

    group.notify(queue: .main) { [weak self] in
      guard let self else { return }

      deselectSelectedAssets(pickerResult: results)

      let nonOptionalImages = images.compactMap { $0 }
      self.delegate?.didSelectImages(nonOptionalImages)
      self.pickerViewController.dismiss(animated: true)
    }
  }

}

// MARK: - Static
extension ImagePicker {

  enum Configurations {
    static let OnePhotoConfiguration: PHPickerConfiguration = {
      var configuration = PHPickerConfiguration(photoLibrary: .shared())
      configuration.filter = .images

      configuration.selectionLimit = 1
      configuration.preferredAssetRepresentationMode = .current
//      configuration.selection = .ordered

      return configuration
    }()
  }

}
