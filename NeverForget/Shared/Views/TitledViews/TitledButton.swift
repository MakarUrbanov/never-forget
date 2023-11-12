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
    let button = ButtonPlaceholder()
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
