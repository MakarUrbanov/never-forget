//
//  TitledTextField.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 22.09.2023.
//

import UIKit

protocol ITitledTextField: ITitledView {
  var textField: EnhancedTextField { get }
  var isRequiredField: Bool { get set }
  func setPlaceholder(_ placeholder: String)
  func setTitle(_ title: String)
  func setError(_ errorText: String)
  func hideError()
}

class TitledTextField: TitledView, ITitledTextField {

  var textField: EnhancedTextField

  init() {
    let textField = Self.getTextField()
    self.textField = textField

    super.init(children: textField)
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public methods
  func setPlaceholder(_ placeholder: String) {
    let attributedString = NSAttributedString(
      string: placeholder,
      attributes: [
        .font: UIFont.systemFont(ofSize: 14, weight: .regular),
        .foregroundColor: UIColor(resource: .textLight100).withAlphaComponent(0.3)
      ]
    )

    textField.attributedPlaceholder = attributedString
  }

}

// MARK: - Static
extension TitledTextField {

  private static func getTextField() -> EnhancedTextField {
    let textField = EnhancedTextField()
    textField.leftView = UIView(frame: .init(origin: .zero, size: .init(width: 16, height: 0)))
    textField.leftViewMode = .always
    return textField
  }

}

// MARK: - Preview
import SwiftUI

#Preview {
  let viewController = UIViewController()
  viewController.view.backgroundColor = UIColor(resource: .darkBackground)
  let textField = TitledTextField()
  textField.isRequiredField = true
  textField.setTitle("Title")
  textField.setPlaceholder("Placeholder...")
  textField.setError("Required field")

  viewController.view.addSubview(textField)

  textField.snp.makeConstraints { make in
    make.center.equalToSuperview()
    make.width.equalToSuperview().multipliedBy(0.8)
    make.height.equalTo(72)
  }

  return viewController.makePreview()
}
