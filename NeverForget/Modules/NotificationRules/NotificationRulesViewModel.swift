//
//  NotificationRulesViewModel.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 26.11.2023.
//

import Foundation

// MARK: - Protocol
protocol INotificationRulesViewModel: AnyObject {
  var event: Event { get }
  var notificationsSchedulingRule: Bindable<Event.NotificationsSchedulingRule> { get }

  func didPressSaveNewRule(_ newRule: Event.NotificationsSchedulingRule)
}

// MARK: - ViewModel
class NotificationRulesViewModel: INotificationRulesViewModel {

  let event: Event
  let notificationsSchedulingRule: Bindable<Event.NotificationsSchedulingRule>

  init(event: Event) {
    self.event = event

    notificationsSchedulingRule = .init(event.notificationScheduleRule)
  }

  func didPressSaveNewRule(_ newRule: Event.NotificationsSchedulingRule) {
    notificationsSchedulingRule.value = newRule
  }

}

// MARK: - Private methods
private extension NotificationRulesViewModel {}
