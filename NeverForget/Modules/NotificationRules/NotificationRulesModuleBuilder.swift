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
    event: Event,
    saveNewNotificationsRuleType: @escaping (RuleType) -> Void
  ) -> INotificationRulesView {
    let viewModel = NotificationRulesViewModel(event: event)
    let view = NotificationRulesView(viewModel: viewModel)

    return view
  }

}