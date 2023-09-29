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
  private let contactImageView = ContactImageView()

  // MARK: - Init
  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .clear

    initialize()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overrides
  override func prepareForReuse() {
    super.prepareForReuse()
    resetView()
  }

  // MARK: - Public methods
  func setImage(_ image: UIImage) {
    contactImageView.setImage(image)
  }

  func setImage(_ data: Data) {
    if let image = UIImage(data: data) {
      setImage(image)
    }
  }

  func setText(_ text: String) {
    contactImageView.setText(text)
  }

  func resetView() {
    contactImageView.resetView()
  }

}

// MARK: - Initialize UI
private extension EventOwnerPhotoView {

  private func initialize() {
    initializeContactImageView()
  }

  private func initializeContactImageView() {
    contentView.addSubview(contactImageView)

    contactImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}
