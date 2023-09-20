//
//  TouchableTableViewCell.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 19.09.2023.
//

import UIKit

class TouchableTableViewCell: UITableViewCell {

  var highlightedAlpha = AppUIConstants.highlightedAlpha
  var highlightAnimationDuration: CGFloat = 0.15

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = .clear
    selectionStyle = .none
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    alpha = 1
  }

  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    setAlpha(by: highlighted)
  }

  private func setAlpha(by highlighted: Bool) {
    UIView.animate(withDuration: highlightAnimationDuration, delay: 0, options: .allowUserInteraction) {
      self.alpha = highlighted ? self.highlightedAlpha : 1
    }
  }

}
