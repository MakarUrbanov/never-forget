//
//  TitledTextField.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 22.09.2023.
//

import UIKit

protocol ITitledTextField: UIStackView {
  var textField: EnhancedTextField { get }
  var isRequiredField: Bool { get set }
  func setPlaceholder(_ placeholder: String)
  func setTitle(_ title: String)
  func setError(_ errorText: String)
  func hideError()
}

class TitledTextField: UIStackView, ITitledTextField {

  var isRequiredField: Bool = false

  lazy var textField: EnhancedTextField = .init()

  private lazy var titleLabel = UILabel()
  private lazy var errorLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: .zero)

    axis = .vertical
    alignment = .fill

    initialize()
  }

  @available(*, unavailable)
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

  func setTitle(_ title: String) {
    titleLabel.text = configureStringByIsRequiredFieldValue(title)
  }

  func setError(_ errorText: String) {
    errorLabel.text = errorText
    textField.layer.borderColor = UIConstants.borderErrorColor.cgColor
  }

  func hideError() {
    errorLabel.text = ""
    textField.layer.borderColor = UIConstants.borderColor.cgColor
  }

}

// MARK: - Private methods
private extension TitledTextField {

  private func configureStringByIsRequiredFieldValue(_ string: String) -> String {
    string + (isRequiredField ? " *" : "")
  }

}

// MARK: - Setup UI
private extension TitledTextField {

  private func initialize() {
    setupTitle()
    configureTextField()
    configureErrorLabel()
  }

  private func setupTitle() {
    titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
    titleLabel.textColor = UIColor(resource: .textLight100)
    titleLabel.numberOfLines = 1
    titleLabel.textAlignment = .left
    titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

    addArrangedSubview(titleLabel)
  }

  private func configureTextField() {
    textField.layer.cornerRadius = 8
    textField.leftView = UIView(frame: .init(origin: .zero, size: .init(width: 16, height: 0)))
    textField.leftViewMode = .always
    textField.layer.borderColor = UIConstants.borderColor.cgColor
    textField.layer.borderWidth = 1
    textField.setContentHuggingPriority(.defaultLow, for: .vertical)

    addArrangedSubview(textField)
    setCustomSpacing(12, after: titleLabel)
  }

  private func configureErrorLabel() {
    errorLabel.font = .systemFont(ofSize: 10, weight: .regular)
    errorLabel.textColor = UIColor(resource: .error100)
    errorLabel.numberOfLines = 1
    errorLabel.textAlignment = .left
    errorLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)

    addArrangedSubview(errorLabel)
    setCustomSpacing(8, after: textField)
  }

}

// MARK: - Static
extension TitledTextField {

  enum UIConstants {
    static let borderColor = UIColor(resource: .textLight100).withAlphaComponent(0.08)
    static let borderErrorColor = UIColor(resource: .error).withAlphaComponent(0.3)
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
  textField.setError("Test error message...")

  viewController.view.addSubview(textField)

  textField.snp.makeConstraints { make in
    make.center.equalToSuperview()
    make.width.equalToSuperview().multipliedBy(0.8)
    make.height.equalTo(80)
  }

  return viewController.makePreview()
}
