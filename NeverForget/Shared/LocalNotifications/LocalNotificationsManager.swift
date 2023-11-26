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

  @discardableResult
  func requestPermission() async -> Bool {
    let isSucceed = await notificationsManager.requestFirstPermission()
    return isSucceed
  }

  func checkAuthorizationStatus() async -> UNAuthorizationStatus {
    return await notificationsManager.checkAuthorizationStatus()
  }

  func scheduleNotification(_ notification: NFLNScheduledEventNotification) async throws {
    do {
      try await notificationsManager.scheduleAnnualNotification(notification)
    } catch {
      throw error
    }
  }

  func getPendingNotifications() async -> [UNNotificationRequest] {
    return await notificationsManager.getPendingNotifications()
  }

  func deleteAllNotifications() async {
    let pendingNotifications = await getPendingNotifications()

    let identifiers = pendingNotifications.reduce([]) { partialResult, notification in
      partialResult + [notification.identifier]
    }

    await notificationsManager.removeNotification(identifiers: identifiers)
  }

  func removePendingNotifications(identifiers: [String]) async {
    await notificationsManager.removeNotification(identifiers: identifiers)
  }

}

// MARK: - Categories & Actions

extension LocalNotificationsManager {

  enum CategoryIdentifiers: String {
    case onBirthday
  }

  func registerCategories() {
    notificationsManager.registerCategories([
      Categories.birthdayNotification,
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
