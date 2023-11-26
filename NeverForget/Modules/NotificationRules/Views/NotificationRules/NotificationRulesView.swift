//
//  NotificationRulesView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.10.2023
//

import UIKit

protocol INotificationRulesView: UIView {
  var parentViewController: UIViewController? { get set }
  var notificationsSchedulingRule: Event.NotificationsSchedulingRule { get }
}

class NotificationRulesView: UIView, INotificationRulesView {

  var presenter: INotificationRulesPresenterInput
  var notificationsSchedulingRule: Event.NotificationsSchedulingRule

  weak var parentViewController: UIViewController?

  private lazy var titleButton: ITitledButton = TitledButton()
//  private lazy var timesTableView = NotificationTimesTableView()

  init(presenter: INotificationRulesPresenterInput, notificationsSchedulingRule: Event.NotificationsSchedulingRule) {
    self.presenter = presenter
    self.notificationsSchedulingRule = notificationsSchedulingRule

    super.init(frame: .zero)

    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

// MARK: - Private methods
extension NotificationRulesView {

  private func dismiss() {
    parentViewController?.dismiss(animated: true)
  }

}

// MARK: - INotificationRulesPresenterOutput
extension NotificationRulesView: INotificationRulesPresenterOutput {

  func openNotificationsTypePicker() {
    let notificationsTypeView = NotificationsTypeSelectorView(initialType: notificationsSchedulingRule)
    notificationsTypeView.setOnSave { [weak self] newType in
      self?.presenter.didPressSave(newType)
    }
    notificationsTypeView.setOnCancel { [weak self] in
      self?.presenter.didPressCancel()
    }

    parentViewController?.presentBottomSheet(notificationsTypeView, detents: [.contentSize])
  }

  func dismissView() {
    dismiss()
  }

  func setNewNotificationsSchedulingRule(_ rule: Event.NotificationsSchedulingRule) {
    titleButton.setText(NotificationTextByType.get(rule))
    notificationsSchedulingRule = rule
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
    let initialText = NotificationTextByType.get(notificationsSchedulingRule)
    titleButton.setText(initialText)
    titleButton.button.addAction(.init(handler: { [weak self] _ in
      self?.presenter.openNotificationsTypePicker()
    }), for: .primaryActionTriggered)

    titleButton.button.configuration?.baseForegroundColor = UIColor(resource: .textLight100)
    titleButton.button.configuration?.titleTextAttributesTransformer = .init({
      $0.merging(.init([
        .font: UIFont.systemFont(ofSize: 14, weight: .regular)
      ]))
    })

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
