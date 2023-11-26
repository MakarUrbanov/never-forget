//
//  NotificationsTypeSelectorView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.11.2023.
//

import UIKit

class NotificationsTypeSelectorView: UIViewController {

  private let initialType: Event.NotificationsSchedulingRule

  private let notificationsTypesTableView: NotificationsTypesTableView
  private lazy var cancelSaveButtons: ICancelSaveButtonsView = CancelSaveButtonsView()

  init(initialType: Event.NotificationsSchedulingRule) {
    self.initialType = initialType
    self.notificationsTypesTableView = NotificationsTypesTableView(initialType: initialType)

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(resource: .darkBackground)
    setupUI()

    view.layoutIfNeeded()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    recomputePreferredSize()
  }

  func setOnSave(_ onSave: @escaping (Event.NotificationsSchedulingRule) -> Void) {
    cancelSaveButtons.onSave = { [weak self] in
      if let selectedType = self?.notificationsTypesTableView.selectedType {
        onSave(selectedType)
      }
    }
  }

  func setOnCancel(_ onCancel: @escaping () -> Void) {
    cancelSaveButtons.onCancel = onCancel
  }

}

// MARK: - Private
private extension NotificationsTypeSelectorView {

  private func recomputePreferredSize() {
    let height = notificationsTypesTableView.bounds.height + cancelSaveButtons.bounds.height + UIConstants.spacing * 2
    self.preferredContentSize = .init(width: preferredContentSize.width, height: height)
  }

}

// MARK: - Setup UI
extension NotificationsTypeSelectorView {

  private func setupUI() {
    setupTypeTableView()
    setupCancelSaveButtons()
  }

  private func setupTypeTableView() {
    view.addSubview(notificationsTypesTableView)

    let height = NotificationsTypesTableView.UIConstants.rowHeight * 3 + UIConstants.spacing
    notificationsTypesTableView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(UIConstants.spacing)
      make.leading.trailing.equalToSuperview().inset(UIConstants.spacing)
      make.height.equalTo(height)
    }
  }

  private func setupCancelSaveButtons() {
    cancelSaveButtons.layer.zPosition = 2
    view.addSubview(cancelSaveButtons)

    cancelSaveButtons.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      make.leading.trailing.equalToSuperview().inset(UIConstants.spacing)
      make.height.equalTo(UIConstants.buttonsHeight)
    }
  }

}

// MARK: - Static
extension NotificationsTypeSelectorView {

  private enum UIConstants {
    static let spacing: CGFloat = 24
    static let buttonsHeight = 44
  }

}

import SwiftUI

#Preview {
  NotificationsTypeSelectorView(initialType: .globalSettings).makePreview()
}
