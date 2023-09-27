//
//  CameraImagePicker.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 25.09.2023.
//

import AVFoundation
import UIKit

// MARK: - Protocol
protocol ICameraImagePicker: AnyObject {
  var cameraController: UIImagePickerController { get }

  static func requestAccess() async -> Bool
}

// MARK: - CameraImagePicker
class CameraImagePicker: ICameraImagePicker {

  private(set) lazy var cameraController = UIImagePickerController()
  var delegate: UIImagePickerControllerDelegate? {
    get {
      cameraController.delegate
    }
    set {
      cameraController.delegate = newValue as? any UIImagePickerControllerDelegate & UINavigationControllerDelegate
    }
  }

  init(
    allowsEditing: Bool = true,
    showsCameraControls: Bool = true
  ) {
    cameraController.sourceType = .camera
    cameraController.cameraCaptureMode = .photo
    cameraController.allowsEditing = allowsEditing
    cameraController.showsCameraControls = showsCameraControls
  }

}

// MARK: - Static
extension CameraImagePicker {

  static func requestAccess() async -> Bool {
    await AVCaptureDevice.requestAccess(for: .video)
  }

}
