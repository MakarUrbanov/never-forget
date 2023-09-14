//
//  NotificationsButton.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.09.2023.
//

import UIKit

protocol INotificationsButton: UIButton {
  var withBadge: Bool { get }

  init(withBadge: Bool)

  func setWithBadge(_ withBadge: Bool)
}

class NotificationsButton: UIButton, INotificationsButton {

  // MARK: - Public properties
  var withBadge: Bool

  // MARK: - Private properties
  private let badge = UIView()

  // MARK: - Init
  required init(withBadge: Bool) {
    self.withBadge = withBadge
    super.init(frame: .zero)

    setImage()
    setWithBadge(withBadge)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public properties
  func setWithBadge(_ withBadge: Bool) {
    self.withBadge = withBadge
    if withBadge {
      setBadge()
    } else {
      removeBadge()
    }
  }
}

// MARK: - Private methods
extension NotificationsButton {

  private func setImage() {
    setImage(UIImage(systemName: "bell.fill"), for: .normal)
    imageView?.tintColor = UIColor(resource: .textLight100)
  }

  private func setBadge() {
    badge.backgroundColor = UIColor(resource: .main100)
    badge.layer.cornerRadius = 3

    addSubview(badge)

    badge.snp.makeConstraints { make in
      make.width.height.equalTo(6)
      make.top.trailing.equalToSuperview()
    }
  }

  private func removeBadge() {
    badge.removeFromSuperview()
  }

}
