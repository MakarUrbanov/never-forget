//
//  NotificationTimesTableViewModel.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 26.11.2023.
//

import Foundation

protocol INotificationTimesTableViewModel: AnyObject {

}

class NotificationTimesTableViewModel: INotificationTimesTableViewModel {

  private var originDate: Date
  private var notificationsDates: Bindable<Set<EventsNotification>>

  init(event: Event) {
    self.originDate = event.originDate
    self.notificationsDates = .init(event.notifications)
  }

}
