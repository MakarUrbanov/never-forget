//
//  CancelSaveButtonsView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.11.2023.
//

import UIKit

protocol ICancelSaveButtonsView: UIStackView {
  var onSave: (() -> Void)? { get set }
  var onCancel: (() -> Void)? { get set }
}

class CancelSaveButtonsView: UIStackView, ICancelSaveButtonsView {

  var onSave: (() -> Void)?
  var onCancel: (() -> Void)?

  private lazy var cancelButton = TouchableButton()
  private lazy var saveButton = TouchableButton()

  override init(frame: CGRect) {
    super.init(frame: frame)

    axis = .horizontal
    distribution = .fillEqually
    spacing = 8

    setupUI()
  }

  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setCancelButtonText(_ text: String) {
    cancelButton.configuration?.attributedTitle = .init(text, attributes: .init([
      .font: UIConstants.font,
    ]))
  }

  func setSaveButtonText(_ text: String) {
    saveButton.configuration?.attributedTitle = .init(text, attributes: .init([
      .font: UIConstants.font,
    ]))
  }

}

// MARK: - Setup UI
private extension CancelSaveButtonsView {

  private func setupUI() {
    setupCancelButton()
    setupSaveButton()
  }

  private func setupCancelButton() {
    addArrangedSubview(cancelButton)

    cancelButton.configuration = .plain()
    cancelButton.configuration?.baseForegroundColor = .white
    cancelButton.configuration?.attributedTitle = .init(String(localized: "Cancel"), attributes: .init([
      .font: UIConstants.font,
    ]))
    cancelButton.layer.cornerRadius = 8
    cancelButton.layer.borderWidth = 1
    cancelButton.layer.borderColor = UIColor(resource: .textLight30).cgColor
    cancelButton.addAction(.init { [weak self] _ in
      self?.onCancel?()
    }, for: .primaryActionTriggered)
  }

  private func setupSaveButton() {
    addArrangedSubview(saveButton)

    saveButton.configuration = .plain()
    saveButton.configuration?.baseForegroundColor = .white
    saveButton.backgroundColor = UIColor(resource: .main100)
    saveButton.configuration?.attributedTitle = .init(String(localized: "Save"), attributes: .init([
      .font: UIConstants.font,
    ]))
    saveButton.layer.cornerRadius = 8
    saveButton.addAction(.init { [weak self] _ in
      self?.onSave?()
    }, for: .primaryActionTriggered)
  }

}

// MARK: - Static
extension CancelSaveButtonsView {

  private enum UIConstants {
    static let font = UIFont.systemFont(ofSize: 14, weight: .regular)
  }

}

// MARK: - Preview
import SwiftUI

#Preview {
  let viewController = UIViewController()
  let cancelSaveButtons = CancelSaveButtonsView()
  viewController.view.addSubview(cancelSaveButtons)

  cancelSaveButtons.snp.makeConstraints { make in
    make.center.equalToSuperview()
    make.horizontalEdges.equalToSuperview().inset(20)
    make.height.equalTo(44)
  }

  return viewController.makePreview()
}
