//
//  TitledView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 29.09.2023.
//

import NFCore
import UIKit

protocol ITitledView: UIStackView {
  var isRequiredField: Bool { get set }
  var children: UIControl { get }

  func setTitle(_ title: String)
  func setError(_ errorText: String)
  func hideError()
}

class TitledView: UIStackView, ITitledView {

  var isRequiredField: Bool = false
  private(set) var children: UIControl

  private lazy var titleStackView = UIStackView()
  private lazy var titleLabel = UILabel()
  private lazy var errorLabel = UILabel()

  init(children: UIControl) {
    self.children = children
    super.init(frame: .zero)

    axis = .vertical
    alignment = .leading

    initialize()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setTitle(_ title: String) {
    titleLabel.text = configureStringByIsRequiredFieldValue(title)
  }

  func setError(_ errorText: String) {
    errorLabel.text = errorText
    children.layer.borderColor = UIConstants.borderErrorColor.cgColor
  }

  func hideError() {
    errorLabel.text = ""
    children.layer.borderColor = UIConstants.borderColor.cgColor
  }

}

// MARK: - Private methods
private extension TitledView {

  private func configureStringByIsRequiredFieldValue(_ string: String) -> String {
    string + (isRequiredField ? " *" : "")
  }

}

// MARK: - Setup UI
private extension TitledView {

  private func initialize() {
    setupTitleStackView()
    setupChildren()
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

  private func setupChildren() {
    children.layer.cornerRadius = 8
    children.layer.borderColor = UIConstants.borderColor.cgColor
    children.layer.borderWidth = 1

    addArrangedSubview(children)
    setCustomSpacing(12, after: titleStackView)

    children.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview()
    }
  }

}

// MARK: - Static
extension TitledView {

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
  let textFieldChildren = UITextField()
  textFieldChildren.placeholder = "TextField children"
  let textField = TitledView(children: textFieldChildren)
  textField.isRequiredField = true
  textField.setTitle("Title")
  textField.setError("Required field")

  viewController.view.addSubview(textField)

  textField.snp.makeConstraints { make in
    make.center.equalToSuperview()
    make.width.equalToSuperview().multipliedBy(0.8)
    make.height.equalTo(72)
  }

  return viewController.makePreview()
}
