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
    saveNewNotificationsRuleType: @escaping (RuleType) -> Void
  ) -> INotificationRulesView {
    let viewModel = NotificationRulesViewModel(notificationsSchedulingRule: notificationsSchedulingRule)
    viewModel.saveNewNotificationsRuleType = saveNewNotificationsRuleType

    let view = NotificationRulesView(viewModel: viewModel)

    return view
  }

}
