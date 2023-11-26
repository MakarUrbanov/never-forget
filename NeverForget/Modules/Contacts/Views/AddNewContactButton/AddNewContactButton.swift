//
//  AddNewContactButton.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 19.09.2023.
//

import UIKit

protocol IAddNewContactButton: UIButton {}

class AddNewContactButton: UIButton, IAddNewContactButton {

  private var presentCreateNewProfile: () -> Void

  init(presentCreateNewProfile: @escaping () -> Void) {
    self.presentCreateNewProfile = presentCreateNewProfile

    super.init(frame: .init(x: 0, y: 0, width: 36, height: 36))

    let tapActions = UIAction { [weak self] _ in
      self?.didTap()
    }
    addAction(tapActions, for: .primaryActionTriggered)

    clipsToBounds = true
    backgroundColor = UIColor(resource: .main100)

    initialize()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    makeCircle()
  }

}

// MARK: - Private methods
private extension AddNewContactButton {

  func didTap() {
    presentCreateNewProfile()
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

    setImage(image, for: .normal)
  }

  private func makeCircle() {
    let radius = bounds.width / 2
    layer.cornerRadius = radius
  }

}
