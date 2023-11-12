//
//  TouchableButton.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.10.2023.
//

import UIKit

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
