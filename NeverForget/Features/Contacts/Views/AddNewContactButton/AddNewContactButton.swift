//
//  AddNewContactButton.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 19.09.2023.
//

import UIKit

protocol IAddNewContactButton: UIButton {

}

class AddNewContactButton: UIButton, IAddNewContactButton {

  init() {
    super.init(frame: .init(x: 0, y: 0, width: 36, height: 36))

    clipsToBounds = true
    backgroundColor = UIColor(resource: .main100)

    initialize()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    makeCircle()
  }

}

// MARK: - Private UI methods
private extension AddNewContactButton {

  private func initialize() {
    initializeImage()
  }

  private func initializeImage() {
    let image = UIImage(systemName: "plus")?.withTintColor(
      UIColor(resource: .textLight100),
      renderingMode: .alwaysOriginal
    )

    self.setImage(image, for: .normal)
  }

  private func makeCircle() {
    let radius = bounds.width / 2
    layer.cornerRadius = radius
  }

}
