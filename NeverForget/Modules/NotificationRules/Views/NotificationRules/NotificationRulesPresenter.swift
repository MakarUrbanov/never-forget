//
//  NotificationRulesPresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.10.2023
//

protocol INotificationRulesPresenterInput: AnyObject {
  var setNewNotificationsRuleType: ((Event.NotificationsSchedulingRule) -> Void)? { get set }

  func openNotificationsTypePicker()
  func didPressSave(_ ruleType: Event.NotificationsSchedulingRule)
  func didPressCancel()
}

protocol INotificationRulesPresenterOutput: AnyObject {
  func openNotificationsTypePicker()
  func dismissView()
  func setNewNotificationsSchedulingRule(_ rule: Event.NotificationsSchedulingRule)
}

class NotificationRulesPresenter {

  var setNewNotificationsRuleType: ((Event.NotificationsSchedulingRule) -> Void)?

  weak var view: INotificationRulesPresenterOutput?

}

// MARK: - Private methods
private extension NotificationRulesPresenter {

  private func saveNewType(_ newType: Event.NotificationsSchedulingRule) {
    setNewNotificationsRuleType?(newType)
    view?.setNewNotificationsSchedulingRule(newType)
  }

}

// MARK: - INotificationRulesPresenterInput
extension NotificationRulesPresenter: INotificationRulesPresenterInput {

  func openNotificationsTypePicker() {
    view?.openNotificationsTypePicker()
  }

  func didPressSave(_ ruleType: Event.NotificationsSchedulingRule) {
    saveNewType(ruleType)
    view?.dismissView()
  }

  func didPressCancel() {
    view?.dismissView()
  }

}
