//
//  TitledButton.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 02.10.2023.
//

import SnapKit
import UIKit

protocol ITitledButton: TitledView {
  var button: UIButton { get }
  func setText(_ text: String)
}

class TitledButton: TitledView, ITitledButton {

  let button: UIButton

  init() {
    let button = Self.getButton()
    self.button = button
    super.init(children: button)
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setText(_ text: String) {
    button.setTitle(text, for: .normal)
  }

}

// MARK: - Static
extension TitledButton {

  private static func getButton() -> UIButton {
    var configuration = UIButton.Configuration.borderless()
    configuration.baseForegroundColor = UIColor(resource: .textLight100)
    configuration.buttonSize = .small
    configuration.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 0)
    let button = TouchableButton(configuration: configuration)
    button.contentHorizontalAlignment = .leading
    return button
  }

}

// MARK: - TouchableButton
extension TitledButton {
  class TouchableButton: UIButton {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      setAnimatedAlpha(AppUIConstants.highlightedAlpha)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesEnded(touches, with: event)
      setAnimatedAlpha(1)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesCancelled(touches, with: event)
      alpha = 1
    }

    private func setAnimatedAlpha(_ alpha: CGFloat) {
      UIView.animate(withDuration: 0.15, delay: 0, options: .allowUserInteraction) {
        self.alpha = alpha
      }
    }
  }
}

// MARK: - Preview
import SwiftUI

#Preview {
  let viewController = UIViewController()
  viewController.view.backgroundColor = UIColor(resource: .darkBackground)
  let button = TitledButton()
  button.setText("05.10.2023")
  button.setTitle("Test title")
  button.setError("Error")
  viewController.view.addSubview(button)

  button.snp.makeConstraints { make in
    make.center.equalToSuperview()
    make.width.equalToSuperview().multipliedBy(0.8)
    make.height.equalTo(60)
  }

  return viewController.makePreview()
}
