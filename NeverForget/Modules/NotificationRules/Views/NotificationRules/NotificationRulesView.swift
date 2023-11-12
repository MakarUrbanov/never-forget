//
//  NotificationRulesView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.10.2023
//

import UIKit

protocol INotificationRulesView: UIView {

}

class NotificationRulesView: UIView, INotificationRulesView {

  var presenter: INotificationRulesPresenterInput

  private let notificationRuleMenu: ITitledMenu
  private lazy var notificationTimesTableView = NotificationTimesTableView()

  init(presenter: INotificationRulesPresenterInput, notificationsSchedulingRule: Event.NotificationsSchedulingRule) {
    self.presenter = presenter

    // TODO: mmk compute initial menu item
    self.notificationRuleMenu = TitledMenuButton(
      menuConfiguration: NotificationsSchedulingMenu.menuConfiguration,
      initialMenuItem: NotificationsSchedulingMenu.defineInitialMenuItem(
        notificationsSchedulingRule: notificationsSchedulingRule
      )
    )

    super.init(frame: .zero)

    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

// MARK: - INotificationRulesPresenterOutput
extension NotificationRulesView: INotificationRulesPresenterOutput {
}

// MARK: - Setup UI
private extension NotificationRulesView {

  private func setupUI() {
    setupNotificationRuleMenu()
  }

  private func setupNotificationRuleMenu() {
    notificationRuleMenu.button.configuration?.baseForegroundColor = UIColor(resource: .textLight100)
    notificationRuleMenu.button.configuration?.titleTextAttributesTransformer = .init({
      $0.merging(.init([
        .font: UIFont.systemFont(ofSize: 14, weight: .regular)
      ]))
    })

    notificationRuleMenu.setTitle(String(localized: "Notifications"))

    addSubview(notificationRuleMenu)

    notificationRuleMenu.snp.makeConstraints { make in
      make.leading.top.trailing.width.equalToSuperview()
      make.height.equalTo(72)
    }
  }

}

// MARK: - Private methods
extension NotificationRulesView {

}
