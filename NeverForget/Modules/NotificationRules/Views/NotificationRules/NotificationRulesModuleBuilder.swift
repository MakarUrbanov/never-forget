//
//  NotificationRulesModuleBuilder.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.10.2023
//

import UIKit

enum NotificationRulesModuleBuilder {

  typealias RuleType = Event.NotificationsSchedulingRule

  static func build(
    notificationsSchedulingRule: RuleType,
    setNewNotificationsRuleType: @escaping (RuleType) -> Void
  ) -> INotificationRulesView {
    let presenter = NotificationRulesPresenter()
    presenter.setNewNotificationsRuleType = setNewNotificationsRuleType
    let view = NotificationRulesView(presenter: presenter, notificationsSchedulingRule: notificationsSchedulingRule)

    presenter.view = view

    return view
  }

}
