//
//  NotificationTimesTableViewModel.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 26.11.2023.
//

import CoreData
import Foundation

protocol INotificationTimesTableViewModel: AnyObject {
  var notificationsDates: Bindable<[EventsNotification]> { get }

  func didPressAddNewTimeButton()
  func deleteTime(_ time: EventsNotification)
}

class NotificationTimesTableViewModel: INotificationTimesTableViewModel {

  private let event: Event
  private var context: NSManagedObjectContext? {
    event.managedObjectContext
  }

  private var originDate: Date {
    event.originDate
  }

  var notificationsDates: Bindable<[EventsNotification]> = .init([])

  init(event: Event) {
    self.event = event

    let sortedTimesArray = Self.sortNotifications(event.notifications)
    notificationsDates.value = sortedTimesArray
  }

  func didPressAddNewTimeButton() {
    guard let highestTime = defineHighestTime(of: notificationsDates.value) else {
      let (defaultHour, defaultMinute) = Constants.defaultTimeComponents
      let notificationTime = createNewNotificationTime(hour: defaultHour, minute: defaultMinute)
      notificationsDates.value.append(notificationTime)

      return
    }

    let newHour = (highestTime.hour?.intValue ?? 0) + 1
    let newMinute = (highestTime.minute?.intValue ?? 0)
    let notificationTime = createNewNotificationTime(hour: newHour, minute: newMinute)
    notificationsDates.value.append(notificationTime)
  }

  func deleteTime(_ time: EventsNotification) {
    guard let index = notificationsDates.value.firstIndex(of: time) else {
      return
    }

    notificationsDates.value.remove(at: index)
  }

}

// MARK: - Add new time
extension NotificationTimesTableViewModel {

  private func defineHighestTime(of times: [EventsNotification]) -> EventsNotification? {
    times.max { lhs, rhs in
      let lhsSum = Self.computeFullMinutesOfNotificationTime(lhs)
      let rhsSum = Self.computeFullMinutesOfNotificationTime(rhs)

      return lhsSum < rhsSum
    }
  }

  private func createNewNotificationTime(hour: Int, minute: Int) -> EventsNotification {
    guard let context else {
      fatalError()
    }

    let notificationTime = EventsNotification(context: context)
    notificationTime.hour = NSNumber(value: hour)
    notificationTime.minute = NSNumber(value: minute)
    notificationTime.event = event

    return notificationTime
  }

}

// MARK: - Static
extension NotificationTimesTableViewModel {

  private static func unwrapOptionalTime(_ time: NSNumber?) -> Int {
    time?.intValue ?? 0
  }

  private static func computeFullMinutesOfNotificationTime(_ notification: EventsNotification) -> Int {
    unwrapOptionalTime(notification.hour) * 60 + unwrapOptionalTime(notification.minute)
  }

  private static func sortNotifications(_ notifications: Set<EventsNotification>) -> [EventsNotification] {
    notifications.sorted { lhs, rhs in
      let lhsSum = computeFullMinutesOfNotificationTime(lhs)
      let rhsSum = computeFullMinutesOfNotificationTime(rhs)

      return lhsSum > rhsSum
    }
  }

  enum Constants {
    static let defaultTimeComponents: (Int, Int) = (10, 0)
  }

}
