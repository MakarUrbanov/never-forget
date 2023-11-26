//
//  EventScreenInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 29.09.2023
//

import Foundation

protocol IEventScreenInteractorInput: AnyObject {
  func getOriginDate() -> Date
  func setOriginDate(date: Date)
  func setNewNotificationsRuleType(_ newType: Event.NotificationsSchedulingRule)
  func getNotificationsSchedulingRule() -> Event.NotificationsSchedulingRule
}

protocol IEventScreenInteractorOutput: AnyObject {}

class EventScreenInteractor: IEventScreenInteractorInput {

  let event: Event
  weak var presenter: IEventScreenInteractorOutput?

  init(event: Event) {
    self.event = event
  }

  func getOriginDate() -> Date {
    event.originDate
  }

  func setOriginDate(date: Date) {
    event.setOriginDate(date)
  }

  func setNewNotificationsRuleType(_ newType: Event.NotificationsSchedulingRule) {
    event.notificationScheduleRule = newType
  }

  func getNotificationsSchedulingRule() -> Event.NotificationsSchedulingRule {
    event.notificationScheduleRule
  }

}
