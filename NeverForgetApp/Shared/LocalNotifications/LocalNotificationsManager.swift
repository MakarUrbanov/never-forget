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

  func scheduleNotification(_ notification: NFLNScheduledEventNotification) {
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

  func removePendingNotifications(identifiers: [String]) {
    notificationsManager.removeNotification(identifiers: identifiers)
  }

}

// MARK: - Categories & Actions

extension LocalNotificationsManager {

  enum CategoryIdentifiers: String {
    case onBirthday
  }

  func registerCategories() {
    notificationsManager.registerCategories([
      Categories.birthdayNotification
    ])
  }

  private enum IntentIdentifiers {
    static let birthday = "BIRTHDAY_INTENT_IDENTIFIER"
  }

  private enum Actions {
    static let accept = UNNotificationAction( // TODO: delete. Test action
      identifier: "ACCEPT_ACTION",
      title: "Accept",
      icon: .init(systemImageName: "checkmark")
    )
  }

  private enum Categories {
    static let birthdayNotification = UNNotificationCategory(
      identifier: CategoryIdentifiers.onBirthday.rawValue,
      actions: [Actions.accept],
      intentIdentifiers: [IntentIdentifiers.birthday]
    )
  }

}
