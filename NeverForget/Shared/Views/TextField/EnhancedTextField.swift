//
//  EnhancedTextField.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 22.09.2023.
//

import UIKit

class EnhancedTextField: UITextField {

  var didChangeValueCallback: DidChangeValueCallback?
  var didPressedKeyboardReturn: DidPressedKeyboardReturnCallback?

  init() {
    super.init(frame: .zero)

    addTarget(self, action: #selector(didChangeValue(_:)), for: .editingChanged)
    delegate = self
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

// MARK: - Private methods
private extension EnhancedTextField {

  @objc
  private func didChangeValue(_ textField: UITextField) {
    let text = textField.text ?? ""
    didChangeValueCallback?(text, textField)
  }

}

// MARK: - Static
extension EnhancedTextField {

  typealias DidChangeValueCallback = (_ text: String, _ textField: UITextField) -> Void
  typealias DidPressedKeyboardReturnCallback = (_ textField: UITextField) -> Void

}

// MARK: - UITextFieldDelegate
extension EnhancedTextField: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    didPressedKeyboardReturn?(textField)

    return true
  }

}
