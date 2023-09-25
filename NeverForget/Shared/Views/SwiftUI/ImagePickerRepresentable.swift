//
//  ImagePickerRepresentable.swift
//  never-forget
//
//  Created by makar on 3/5/23.
//

import Foundation
import PhotosUI
import SwiftUI
import UIKit

struct ImagePickerRepresentable: UIViewControllerRepresentable {
  typealias UIViewControllerType = PHPickerViewController

  @Binding var selectedImage: Data?
  @Binding var isLoading: Bool
  let onDismiss: (() -> Void)?

  private let pickerConfiguration: PHPickerConfiguration = {
    var config = PHPickerConfiguration()
    config.filter = PHPickerFilter.not(.videos)
    config.selection = .default
    config.selectionLimit = 1

    return config
  }()

  init(selectedImage: Binding<Data?>, isLoading: Binding<Bool>, onDismiss: (() -> Void)? = nil) {
    _selectedImage = selectedImage
    _isLoading = isLoading
    self.onDismiss = onDismiss
  }

  func makeUIViewController(context: Context) -> PHPickerViewController {
    let picker = PHPickerViewController(configuration: pickerConfiguration)
    picker.delegate = context.coordinator
    return picker
  }

  func updateUIViewController(_: PHPickerViewController, context _: Context) {}

  func makeCoordinator() -> Coordinator {
    Coordinator(selectedImage: $selectedImage, isLoading: $isLoading, onDismiss: onDismiss)
  }

  class Coordinator: NSObject, PHPickerViewControllerDelegate {
    @Binding var selectedImage: Data?
    @Binding var isLoading: Bool
    let onDismiss: (() -> Void)?

    init(selectedImage: Binding<Data?>, isLoading: Binding<Bool>, onDismiss: (() -> Void)?) {
      _selectedImage = selectedImage
      _isLoading = isLoading
      self.onDismiss = onDismiss
    }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      isLoading = true
      picker.dismiss(animated: true)

      guard
        let item = results.first?.itemProvider,
        item.canLoadObject(ofClass: UIImage.self) else
      {
        isLoading = false
        return
      }

      item.loadObject(ofClass: UIImage.self) { image, error in
        if let error {
          Logger.error(message: "IMAGE PICKER ERROR", error)
          self.isLoading = false
          return
        }

        DispatchQueue.main.async {
          if let image = image as? UIImage {
            self.selectedImage = image.pngData()
            self.isLoading = false
          }
        }
      }
    }
  }

}
