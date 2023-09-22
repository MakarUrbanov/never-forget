//
//  TitledTextField.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 22.09.2023.
//

import UIKit

protocol ITitledTextField: UIView {
  var textField: EnhancedTextField { get }
  var isRequiredField: Bool { get set }
  func setPlaceholder(_ placeholder: String)
  func setTitle(_ title: String)
}

class TitledTextField: UIView, ITitledTextField {

  var isRequiredField: Bool = false

  var textField: EnhancedTextField = .init()

  private lazy var titleLabel = UILabel()

  override init(frame: CGRect) {
    super.init(frame: .zero)

    initialize()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
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
  }

  private func setupTitle() {
    titleLabel.font = .systemFont(ofSize: 12, weight: .bold)
    titleLabel.textColor = UIColor(resource: .textLight100)
    titleLabel.numberOfLines = 1
    titleLabel.textAlignment = .left

    addSubview(titleLabel)

    titleLabel.snp.makeConstraints { make in
      make.leading.top.trailing.equalToSuperview()
    }
  }

  private func configureTextField() {
    textField.layer.cornerRadius = 8
    textField.leftView = UIView(frame: .init(origin: .zero, size: .init(width: 16, height: 0)))
    textField.leftViewMode = .always
    textField.layer.borderColor = UIColor(resource: .textLight100).withAlphaComponent(0.08).cgColor
    textField.layer.borderWidth = 1

    addSubview(textField)

    textField.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.top.equalTo(titleLabel.snp.bottom).offset(12)
    }
  }

}
