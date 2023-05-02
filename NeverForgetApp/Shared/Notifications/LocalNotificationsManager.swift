//
//  LocalNotificationsManager.swift
//  NeverForgetApp
//
//  Created by makar on 5/1/23.
//

import Foundation
import NFLocalNotificationsManager
import UserNotifications

final class LocalNotificationsManager {
  static let shared = LocalNotificationsManager()
  private init() {}

  private let notificationsManager = NFLocalNotificationsManager()

  func requestPermission() {
    notificationsManager.requestFirstPermission()
  }

  func scheduleNotification(_ notification: LocalNotification) {
    let notification = NFLNScheduledEventNotification(
      identifier: notification.identifier,
      title: notification.title,
      body: notification.body,
      date: notification.date,
      deepLink: notification.deepLink,
      categoryIdentifier: notification.categoryIdentifier?.rawValue
    )

    notificationsManager.scheduleAnnualNotification(notification) { errorMessage in
      Logger.error(message: "Scheduling notification error", errorMessage)
    }
  }

  func getPendingNotifications(completion: @escaping ([UNNotificationRequest]) -> Void) {
    notificationsManager.getPendingNotifications { notifications in
      completion(notifications)
    }
  }

  func deleteAllNotifications() {
    getPendingNotifications { notifications in
      let identifiers = notifications.reduce([]) { partialResult, notification in
        partialResult + [notification.identifier]
      }

      self.notificationsManager.removeNotification(identifiers: identifiers)
    }
  }

  func removePendingNotification(identifier: String) {
    notificationsManager.removeNotification(identifiers: [identifier])
  }

}

// MARK: - Categories

extension LocalNotificationsManager {

  private enum IntentIdentifiers {
    static let birthday = "BIRTHDAY_INTENT_IDENTIFIER"
  }

  private enum Actions {
    static let accept = UNNotificationAction(
      identifier: "ACCEPT_ACTION",
      title: "Accept",
      icon: .init(systemImageName: "checkmark")
    )
  }

  private enum Categories {
    static let birthdayNotification = UNNotificationCategory(
      identifier: NotificationsCategoryIdentifiers.onBirthday.rawValue,
      actions: [Actions.accept],
      intentIdentifiers: [IntentIdentifiers.birthday]
    )
  }

  func registerCategories() {
    notificationsManager.registerCategories([Categories.birthdayNotification])
  }

}
