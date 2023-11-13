//
//  TouchableUIControl.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 25.09.2023.
//

import UIKit

class TouchableUIControl: UIControl {

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

}
