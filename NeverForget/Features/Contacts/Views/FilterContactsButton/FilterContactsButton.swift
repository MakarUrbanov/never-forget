//
//  FilterContactsButton.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 19.09.2023.
//

import UIKit

protocol IFilterContactsButton: UIControl {
  var highlightedAlpha: CGFloat { get set }
}

class FilterContactsButton: UIControl, IFilterContactsButton {

  var filterIcon = UIImageView(image: UIImage(named: "filterIcon"))
  var highlightedAlpha: CGFloat = AppUIConstants.highlightedAlpha

  init() {
    super.init(frame: .zero)

    self.snp.makeConstraints { make in
      make.width.height.greaterThanOrEqualTo(36)
    }

    initialize()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    self.alpha = highlightedAlpha
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)

    self.alpha = 1
  }

}

// MARK: - Private ui methods
private extension FilterContactsButton {

  private func initialize() {
    initializeFilterIcon()
  }

  private func initializeFilterIcon() {
    filterIcon.contentMode = .scaleAspectFit

    addSubview(filterIcon)

    filterIcon.snp.makeConstraints { make in
      make.width.height.equalTo(20)
      make.center.equalToSuperview()
    }
  }

}


import SwiftUI

#Preview {
  FilterContactsButton()
}
