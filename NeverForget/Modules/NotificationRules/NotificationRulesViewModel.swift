//
//  NotificationRulesViewModel.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 26.11.2023.
//

import Foundation

// MARK: - Protocol
protocol INotificationRulesViewModel: AnyObject {
  var notificationsSchedulingRule: Bindable<Event.NotificationsSchedulingRule> { get }

  var saveNewNotificationsRuleType: ((Event.NotificationsSchedulingRule) -> Void)? { get set }

  func didPressSave(_ newRule: Event.NotificationsSchedulingRule)
}

// MARK: - ViewModel
class NotificationRulesViewModel: INotificationRulesViewModel {

  // MARK: - Properties
  let notificationsSchedulingRule: Bindable<Event.NotificationsSchedulingRule>

  // MARK: - Callback
  var saveNewNotificationsRuleType: ((Event.NotificationsSchedulingRule) -> Void)?

  // MARK: - Init
  init(notificationsSchedulingRule: Event.NotificationsSchedulingRule) {
    self.notificationsSchedulingRule = .init(notificationsSchedulingRule)
  }

  // MARK: - Methods
  func didPressSave(_ newRule: Event.NotificationsSchedulingRule) {
    notificationsSchedulingRule.value = newRule
    saveNewNotificationsRuleType?(newRule)
  }

}
