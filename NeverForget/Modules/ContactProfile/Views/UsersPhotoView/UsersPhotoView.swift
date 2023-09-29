//
//  UsersPhotoView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 25.09.2023.
//

import NFCore
import UIKit

protocol IUsersPhotoViewDelegate: AnyObject {
  func didPressDeleteImage()
  func didPressAddImage()
  func didPressOnBodyWith(image: UIImage?)
}

protocol IUsersPhotoView: UIControl {
  var delegate: IUsersPhotoViewDelegate? { get set }

  func setImage(_ image: UIImage)
  func reset()
}

class UsersPhotoView: TouchableUIControl, IUsersPhotoView {

  weak var delegate: IUsersPhotoViewDelegate?

  // MARK: - UI
  private lazy var imageView = UIImageView()
  private lazy var actionButtonView = UsersPhotoActionButtonView()
  private lazy var cameraIconView = UIImageView(image: UIImage(systemName: "camera")?.withTintColor(
    UIColor(resource: .textLight100), renderingMode: .alwaysOriginal
  ))

  // MARK: - Init
  init() {
    super.init(frame: .zero)

    initialize()

    actionButtonView.addTarget(self, action: #selector(didPressActionButton), for: .touchUpInside)
    addTarget(self, action: #selector(didPressSelf), for: .touchUpInside)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overrides
  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.setCircleRadius()
  }

  // MARK: - Public methods
  func setImage(_ image: UIImage) {
    imageView.image = image
    imageView.layer.borderColor = Resources.withImageBorderColor.cgColor
    setTrashButton()
    cameraIconView.isHidden = true
  }

  func reset() {
    imageView.image = nil
    imageView.layer.borderColor = Resources.withoutImageBorderColor.cgColor
    setAddButton()
    cameraIconView.isHidden = false
  }

}

// MARK: - Private methods
private extension UsersPhotoView {

  private func setAddButton() {
    actionButtonView.setImage(Resources.plusIcon)
    actionButtonView.backgroundColor = Resources.plusIconBackgroundColor
  }

  private func setTrashButton() {
    actionButtonView.setImage(Resources.trashIcon)
    actionButtonView.backgroundColor = Resources.trashIconBackgroundColor
  }

  @objc
  private func didPressActionButton(_ sender: UIControl) {
    if imageView.image == nil {
      delegate?.didPressAddImage()
    } else {
      delegate?.didPressDeleteImage()
    }
  }

  @objc
  private func didPressSelf(_ sender: UIControl) {
    delegate?.didPressOnBodyWith(image: imageView.image)
  }

}

// MARK: - Initialize UI
private extension UsersPhotoView {

  private func initialize() {
    setupImageView()
    setupActionButtonView()
    setupCameraView()
  }

  private func setupImageView() {
    imageView.clipsToBounds = true
    imageView.contentMode = .scaleAspectFill
    imageView.layer.borderWidth = 1
    imageView.layer.borderColor = Resources.withoutImageBorderColor.cgColor

    addSubview(imageView)

    imageView.snp.makeConstraints { make in
      make.height.equalToSuperview()
      make.width.equalTo(imageView.snp.height)
      make.center.equalToSuperview()
    }
  }

  private func setupActionButtonView() {
    actionButtonView.layer.cornerRadius = UIConstants.buttonSize / 2
    setAddButton()

    addSubview(actionButtonView)

    actionButtonView.snp.makeConstraints { make in
      make.width.height.equalTo(UIConstants.buttonSize)
      make.trailing.equalTo(imageView.snp.trailing)
      make.top.equalTo(imageView.snp.top)
    }
  }

  private func setupCameraView() {
    cameraIconView.layer.zPosition = 1
    cameraIconView.contentMode = .scaleAspectFit

    addSubview(cameraIconView)

    cameraIconView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.height.equalToSuperview().multipliedBy(0.3)
    }
  }

}

// MARK: - Static
extension UsersPhotoView {

  enum Resources {
    static let cameraIcon = UIImage(systemName: "camera")!.withTintColor(
      UIColor(resource: .textLight100), renderingMode: .alwaysOriginal
    )
    static let trashIcon = UIImage(systemName: "trash")!.withTintColor(
      UIColor(resource: .darkBackground), renderingMode: .alwaysOriginal
    )
    static let trashIconBackgroundColor = UIColor(resource: .textLight100)
    static let plusIcon = UIImage(systemName: "plus")!.withTintColor(
      UIColor(resource: .textLight100), renderingMode: .alwaysOriginal
    )
    static let plusIconBackgroundColor = UIColor(resource: .main100)

    static let withImageBorderColor = UIColor(resource: .textLight100)
    static let withoutImageBorderColor = UIColor(resource: .textLight100).withAlphaComponent(0.08)
  }

  enum UIConstants {
    static let buttonSize: CGFloat = 32
  }

}

// MARK: - Preview
import SwiftUI

#Preview {
  let viewController = UIViewController()
  viewController.view.backgroundColor = UIColor(resource: .darkBackground)
  let photoView = UsersPhotoView()

  viewController.view.addSubview(photoView)

  photoView.snp.makeConstraints { make in
    make.center.equalToSuperview()
    make.width.height.equalTo(110)
  }


  return viewController.makePreview()
}
