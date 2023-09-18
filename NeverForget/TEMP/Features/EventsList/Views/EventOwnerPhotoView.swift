//
//  EventOwnerPhotoView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023.
//

import UIKit

protocol IEventOwnerPhotoView: UICollectionViewCell {
  func setImage(_ image: UIImage)
  func setImage(_ data: Data)
  func setText(_ text: String)
  func resetView()
}

class EventOwnerPhotoView: UICollectionViewCell, IEventOwnerPhotoView {

  // MARK: - Private properties
  private let imageView = UIImageView()
  private let letterLabel = UILabel()

  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .clear
    clipsToBounds = true
    layer.borderWidth = 1
    layer.borderColor = UIColor(resource: .textLight100).cgColor

    initialize()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overrides
  override func prepareForReuse() {
    super.prepareForReuse()
    resetView()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    setCornerRadius()
  }

  // MARK: - Public methods
  func setImage(_ image: UIImage) {
    imageView.image = image
  }

  func setImage(_ data: Data) {
    if let image = UIImage(data: data) {
      setImage(image)
    }
  }

  func setText(_ text: String) {
    letterLabel.text = text
    letterLabel.isHidden = false
  }

  func resetView() {
    letterLabel.isHidden = true
    letterLabel.text = ""

    imageView.image = nil
  }

}

// MARK: - Initialize UI
private extension EventOwnerPhotoView {

  private func initialize() {
    initializeImageView()
    initializeLetterLabel()
  }

  private func initializeImageView() {
    imageView.contentMode = .scaleAspectFill

    contentView.addSubview(imageView)

    imageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func initializeLetterLabel() {
    letterLabel.layer.zPosition = 1
    letterLabel.font = .systemFont(ofSize: 16, weight: .regular)
    letterLabel.numberOfLines = 0
    letterLabel.isHidden = true
    letterLabel.textAlignment = .center
    letterLabel.backgroundColor = UIColor(resource: .darkBackground)

    contentView.addSubview(letterLabel)

    letterLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}

// MARK: - Private methods
extension EventOwnerPhotoView {

  private func setCornerRadius() {
    let radius = bounds.width / 2
    layer.cornerRadius = radius
  }

}
