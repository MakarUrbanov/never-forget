//
//  PersonProfileNotificationsManager.swift
//  NeverForgetApp
//
//  Created by makar on 5/1/23.
//

import Foundation
import NFLocalNotificationsManager

// swiftlint:disable force_unwrapping
// swiftlint:disable force_cast
class PersonProfileNotificationsManager {

  private var appSettingsManager: AppSettingsManager
  private let notificationsManager = LocalNotificationsManager.shared

  init() {
    appSettingsManager = AppSettingsManager()
  }

  func rescheduleBirthdayNotifications(
    for person: Person,
    completion: @escaping (Bool) -> Void
  ) {
    /// fetching settings
    appSettingsManager.fetch { settings in
      guard let settings else {
        completion(false)
        return
      }

      let usersObjectUrl = PersonProfileNotificationsManager.getUserIdFromPersonObject(person)

      // delete pended notifications
      self.deleteAllNotifications(with: usersObjectUrl) {
        let generatedNotifications = PersonProfileNotificationsManager.generateNotifications(
          for: person,
          settings: settings
        )

        // schedule notifications
        generatedNotifications.forEach { notification in
          self.notificationsManager.scheduleNotification(notification)
        }
      }
    }
  }

  func deleteAllNotifications(with prefix: String, completion: @escaping () -> Void) {
    notificationsManager.getPendingNotifications { notifications in
      for notification in notifications where notification.identifier.hasPrefix(prefix) {
        self.notificationsManager.removePendingNotifications(identifiers: [notification.identifier])
      }

      completion()
    }
  }

}

// MARK: - Notifications

extension PersonProfileNotificationsManager {

  /// Makes array of notifications with settings and times from the app settings
  private static func generateNotifications(
    for person: Person,
    settings: AppSettings
  ) -> [NFLNScheduledEventNotification] {
    guard
      let isNotificationOnEventDayEnabled = settings.appNotificationRules?.isNotificationOnEventDayEnabled,
      let isNotificationOneDayBeforeEnabled = settings.appNotificationRules?.isNotificationOneDayBeforeEnabled,
      let isNotificationOneWeekBeforeEnabled = settings.appNotificationRules?.isNotificationOneWeekBeforeEnabled,
      let onEventDayTimes = settings.appNotificationRules?.onEventDayTimes,
      let timeOnOneDayBefore = settings.appNotificationRules?.timeOnOneDayBefore,
      let timeOnOneWeekBefore = settings.appNotificationRules?.timeOnOneWeekBefore else
    {
      return []
    }

    var notifications: [NFLNScheduledEventNotification] = []

    if isNotificationOneWeekBeforeEnabled {
      let notification = generateNotificationForOneWeekBefore(person: person, timeOnOneWeekBefore: timeOnOneWeekBefore)
      notifications.append(notification)
    }

    if isNotificationOneDayBeforeEnabled {
      let notification = generateNotificationForOneDayBefore(person: person, timeOnOneDayBefore: timeOnOneDayBefore)
      notifications.append(notification)
    }

    if isNotificationOnEventDayEnabled {
      let atBirthdayDateNotifications = generateNotificationForBirthdayDate(
        person: person,
        onEventDayTimes: onEventDayTimes
      )

      notifications += atBirthdayDateNotifications
    }

    return notifications
  }

  /// Generates a notification 1 WEEK before the birthday
  private static func generateNotificationForOneWeekBefore(
    person: Person,
    timeOnOneWeekBefore: AppNotificationTime
  ) -> NFLNScheduledEventNotification {
    let dateOfBirth = person.dateOfBirth!
    let userId = getUserIdFromPersonObject(person)
    let notificationDate = combineOnEventDayTimesWithBirthdayDate(
      birthdayDate: dateOfBirth,
      onEventDayTimes: [timeOnOneWeekBefore],
      daysOffset: -7
    ).first!

    let identifier = generateIdentifier(
      userId: userId,
      notificationDate: notificationDate
    )

    return generateBirthdayNotification(
      identifier: identifier,
      date: notificationDate,
      type: .oneWeekBefore,
      person: person
    )
  }

  /// Generates a notification 1 DAY before the birthday
  private static func generateNotificationForOneDayBefore(
    person: Person,
    timeOnOneDayBefore: AppNotificationTime
  ) -> NFLNScheduledEventNotification {
    let dateOfBirth = person.dateOfBirth!
    let userId = getUserIdFromPersonObject(person)
    let notificationDate = combineOnEventDayTimesWithBirthdayDate(
      birthdayDate: dateOfBirth,
      onEventDayTimes: [timeOnOneDayBefore],
      daysOffset: -1
    ).first!

    let identifier = generateIdentifier(
      userId: userId,
      notificationDate: notificationDate
    )

    return generateBirthdayNotification(
      identifier: identifier,
      date: notificationDate,
      type: .oneDayBefore,
      person: person
    )
  }

  /// Generates birthday notifications
  private static func generateNotificationForBirthdayDate(
    person: Person,
    onEventDayTimes: NSSet
  ) -> [NFLNScheduledEventNotification] {
    let dateOfBirth = person.dateOfBirth!
    let userId = getUserIdFromPersonObject(person)
    let notificationDates = combineOnEventDayTimesWithBirthdayDate(
      birthdayDate: dateOfBirth,
      onEventDayTimes: onEventDayTimes.allObjects as! [AppNotificationTime],
      daysOffset: 0
    )

    return notificationDates.map { notificationTime in
      let identifier = generateIdentifier(
        userId: userId,
        notificationDate: notificationTime
      )

      return generateBirthdayNotification(
        identifier: identifier,
        date: notificationTime,
        type: .onEventDate,
        person: person
      )
    }
  }

}


// MARK: - Helpers

extension PersonProfileNotificationsManager {

  private static func getUserIdFromPersonObject(_ person: Person) -> String {
    person.objectID.uriRepresentation().absoluteString
  }


  private static func generateIdentifier(userId: String, notificationDate: Date) -> String {
    let calendar = Calendar.current
    let month = calendar.component(.month, from: notificationDate)
    let day = calendar.component(.day, from: notificationDate)
    let hour = calendar.component(.hour, from: notificationDate)
    let minute = calendar.component(.minute, from: notificationDate)
    return "\(userId)-\(month)-\(day)-\(hour)-\(minute)"
  }

  private static func combineOnEventDayTimesWithBirthdayDate(
    birthdayDate: Date,
    onEventDayTimes: [AppNotificationTime],
    daysOffset: Int = 0
  ) -> [Date] {
    onEventDayTimes.compactMap { time in
      let hours = Int(time.hours)
      let minutes = Int(time.minutes)
      let date = Calendar.current.date(bySettingHour: hours, minute: minutes, second: 0, of: birthdayDate)!

      return Calendar.current.date(byAdding: .day, value: daysOffset, to: date)
    }
  }

  private static func generateBirthdayNotification(
    identifier: String,
    date: Date,
    type: LocalNotificationForBirthday.BirthdayNotificationType,
    person: Person
  ) -> NFLNScheduledEventNotification {
    let username = person.name ?? "Unnamed" // TODO: translate
    let imageData = person.photo

    return LocalNotificationsFactory.makeNotification(for: .onBirthday(.init(
      type: type,
      identifier: identifier,
      username: username,
      date: date,
      imageData: imageData
    )))
  }

}
