//
//  UserImageView.swift
//  NeverForgetApp
//
//  Created by makar on 5/13/23.
//

import UIKit

final class UserImageView: UIImageView {

  private var imageData: Data?

  let activityIndicator: UIActivityIndicatorView = {
    let view = UIActivityIndicatorView(style: .medium)
    view.hidesWhenStopped = true
    return view
  }()

  let placeholderImage: UIImageView = {
    let view = UIImageView(image: UIImage(systemName: "person"))
    return view
  }()

  init(data: Data? = nil) {
    super.init(image: nil)

    setViews()
    setConstraints()
    setAppearanceConfiguration()

    loadImageFromData(data)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func loadImageFromData(_ data: Data?) {
    if imageData == data {
      return
    }

    imageData = data

    guard let data else {
      placeholderImage.isHidden = false
      image = nil
      return
    }

    activityIndicator.startAnimating()
    placeholderImage.isHidden = true

    AsyncImageLoader.shared.fromData(data) { [weak self] image in
      self?.image = image
      self?.activityIndicator.stopAnimating()
    }
  }

}

extension UserImageView {
  func setViews() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    addSubview(activityIndicator)
    placeholderImage.translatesAutoresizingMaskIntoConstraints = false
    addSubview(placeholderImage)
  }

  func setConstraints() {
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),

      placeholderImage.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
      placeholderImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
      placeholderImage.centerXAnchor.constraint(equalTo: centerXAnchor),
      placeholderImage.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }

  func setAppearanceConfiguration() {
    contentMode = .scaleAspectFill
    clipsToBounds = true
  }
}
