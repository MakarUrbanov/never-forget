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

  private lazy var titleStackView = UIStackView()
  private lazy var titleLabel = UILabel()
  private lazy var errorLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: .zero)

    axis = .vertical
    alignment = .leading

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
    setupTitleStackView()
    setupTextField()
  }

  private func setupTitleStackView() {
    titleStackView.axis = .horizontal
    titleStackView.distribution = .fill
    titleStackView.setContentHuggingPriority(.defaultHigh, for: .vertical)
    titleStackView.spacing = 8

    addArrangedSubview(titleStackView)

    titleStackView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview()
    }

    setupTitle()
    setupErrorLabel()
  }

  private func setupTitle() {
    titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
    titleLabel.textColor = UIColor(resource: .textLight100)
    titleLabel.numberOfLines = 1
    titleLabel.textAlignment = .left
    titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

    titleStackView.addArrangedSubview(titleLabel)
  }

  private func setupErrorLabel() {
    errorLabel.font = .systemFont(ofSize: 10, weight: .regular)
    errorLabel.textColor = UIColor(resource: .error100)
    errorLabel.text = ""

    errorLabel.numberOfLines = 1
    errorLabel.textAlignment = .left
    errorLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    errorLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    titleStackView.addArrangedSubview(errorLabel)
  }

  private func setupTextField() {
    textField.layer.cornerRadius = 8
    textField.leftView = UIView(frame: .init(origin: .zero, size: .init(width: 16, height: 0)))
    textField.leftViewMode = .always
    textField.layer.borderColor = UIConstants.borderColor.cgColor
    textField.layer.borderWidth = 1

    addArrangedSubview(textField)
    setCustomSpacing(12, after: titleStackView)

    textField.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview()
    }
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
  textField.setError("Required field")

  viewController.view.addSubview(textField)

  textField.snp.makeConstraints { make in
    make.center.equalToSuperview()
    make.width.equalToSuperview().multipliedBy(0.8)
    make.height.equalTo(72)
  }

  return viewController.makePreview()
}
