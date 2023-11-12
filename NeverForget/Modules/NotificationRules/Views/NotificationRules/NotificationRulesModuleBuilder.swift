//
//  NotificationRulesModuleBuilder.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.10.2023
//

import UIKit

enum NotificationRulesModuleBuilder {

  static func build(notificationsSchedulingRule: Event.NotificationsSchedulingRule) -> INotificationRulesView {
    let presenter = NotificationRulesPresenter()
    let view = NotificationRulesView(presenter: presenter, notificationsSchedulingRule: notificationsSchedulingRule)

    presenter.view = view

    return view
  }

}
