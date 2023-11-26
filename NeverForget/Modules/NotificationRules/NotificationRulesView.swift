//
//  NotificationRulesView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.10.2023
//

import UIKit

protocol INotificationRulesView: UIView {
  var parentViewController: UIViewController? { get set }
}

class NotificationRulesView: UIView, INotificationRulesView {

  var viewModel: INotificationRulesViewModel

  weak var parentViewController: UIViewController?

  private lazy var titleButton: ITitledButton = TitledButton()
//  private lazy var timesTableView = NotificationTimesTableView()

  init(viewModel: INotificationRulesViewModel) {
    self.viewModel = viewModel

    super.init(frame: .zero)

    setupUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

// MARK: - Private methods
extension NotificationRulesView {

  private func dismiss() {
    parentViewController?.dismiss(animated: true)
  }

  private func didPressSaveNotificationsType(newRule: Event.NotificationsSchedulingRule) {
    viewModel.didPressSave(newRule)

    let newRuleTitle = NotificationTextByType.get(newRule)
    titleButton.setText(newRuleTitle)

    dismiss()
  }

  private func didPressCancelNotificationsType() {
    dismiss()
  }

  private func openNotificationsTypePicker() {
    let notificationsTypeView = NotificationsTypeSelectorView(initialType: viewModel.notificationsSchedulingRule.value)
    notificationsTypeView.setOnSave { [weak self] newRule in
      self?.didPressSaveNotificationsType(newRule: newRule)
    }
    notificationsTypeView.setOnCancel { [weak self] in
      self?.didPressCancelNotificationsType()
    }

    parentViewController?.presentBottomSheet(notificationsTypeView, detents: [.contentSize])
  }

}

// MARK: - Setup UI
private extension NotificationRulesView {

  private func setupUI() {
    setupNotificationRuleMenu()
  }

  private func setupNotificationRuleMenu() {
    titleButton.isRequiredField = true
    titleButton.setTitle(String(localized: "Notifications"))
    let initialText = NotificationTextByType.get(viewModel.notificationsSchedulingRule.value)
    titleButton.setText(initialText)
    titleButton.button.addAction(.init(handler: { [weak self] _ in
      self?.openNotificationsTypePicker()
    }), for: .primaryActionTriggered)

    titleButton.button.configuration?.baseForegroundColor = UIColor(resource: .textLight100)
    titleButton.button.configuration?.titleTextAttributesTransformer = .init {
      $0.merging(.init([
        .font: UIFont.systemFont(ofSize: 14, weight: .regular),
      ]))
    }

    addSubview(titleButton)

    titleButton.snp.makeConstraints { make in
      make.leading.top.trailing.width.equalToSuperview()
      make.height.equalTo(UIConstants.fieldHeight)
    }
  }

}

// MARK: - Static
extension NotificationRulesView {

  private enum UIConstants {
    static let fieldHeight: CGFloat = 72
  }

}
