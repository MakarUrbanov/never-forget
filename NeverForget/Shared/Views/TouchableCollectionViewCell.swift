//
//  TouchableCollectionViewCell.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 23.12.2023.
//

import UIKit

class TouchableCollectionViewCell: UICollectionViewCell {

  var highlightedAlpha = AppUIConstants.highlightedAlpha
  var highlightAnimationDuration: CGFloat = 0.15

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .clear
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    alpha = 1
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    setAlpha(isTouched: true)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    setAlpha(isTouched: false)
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    setAlpha(isTouched: false)
  }

  private func setAlpha(isTouched: Bool) {
    UIView.animate(withDuration: highlightAnimationDuration, delay: 0, options: .allowUserInteraction) {
      self.alpha = isTouched ? self.highlightedAlpha : 1
    }
  }

}
