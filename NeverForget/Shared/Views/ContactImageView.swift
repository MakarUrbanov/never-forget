//
//  ContactImageView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 19.09.2023.
//

import UIKit

protocol IContactImageView: UIImageView {
  var letterLabel: UILabel { get }
  var isCircle: Bool { get }

  func setImage(_ image: UIImage)
  func setImage(_ data: Data)
  func setText(_ text: String)
  func resetView()
}

class ContactImageView: UIImageView, IContactImageView {

  let letterLabel = UILabel()
  var isCircle: Bool

  init(isCircle: Bool = true) {
    self.isCircle = isCircle
    super.init(frame: .zero)

    contentMode = .scaleAspectFill
    backgroundColor = .clear
    clipsToBounds = true
    layer.borderWidth = 1
    layer.borderColor = UIColor(resource: .textLight100).cgColor

    initialize()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    if isCircle {
      setCircleRadius()
    }
  }

  func setImage(_ image: UIImage) {
    self.image = image
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

    image = nil
  }

}

// MARK: - Private methods
private extension ContactImageView {

  private func setCircleRadius() {
    let radius = bounds.width / 2
    layer.cornerRadius = radius
  }

}

// MARK: - Initialize UI
private extension ContactImageView {

  private func initialize() {
    initializeLetterLabel()
  }

  private func initializeLetterLabel() {
    letterLabel.layer.zPosition = 1
    letterLabel.font = .systemFont(ofSize: 16, weight: .regular)
    letterLabel.numberOfLines = 0
    letterLabel.isHidden = true
    letterLabel.textAlignment = .center
    letterLabel.backgroundColor = UIColor(resource: .darkBackground)

    addSubview(letterLabel)

    letterLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}
