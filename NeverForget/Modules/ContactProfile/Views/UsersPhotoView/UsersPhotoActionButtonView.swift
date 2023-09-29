//
//  UsersPhotoActionButtonView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 25.09.2023.
//

import NFCore
import UIKit

protocol IUsersPhotoActionButtonView: UIView {
  func setImage(_ image: UIImage)
}

class UsersPhotoActionButtonView: TouchableUIControl, IUsersPhotoActionButtonView {

  private lazy var imageView = UIImageView()

  init() {
    super.init(frame: .zero)

    initialize()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    setCircleRadius()
  }

  func setImage(_ image: UIImage) {
    imageView.image = image
  }

}

// MARK: - Setup UI
private extension UsersPhotoActionButtonView {

  private func initialize() {
    setupImageView()
  }

  private func setupImageView() {
    imageView.contentMode = .scaleAspectFit

    addSubview(imageView)

    imageView.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.width.height.equalToSuperview().multipliedBy(0.5)
    }
  }

}
