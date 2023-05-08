//
//  PersonNotificationsPermissionInfoBlockViewModel.swift
//  NeverForgetApp
//
//  Created by makar on 5/7/23.
//

import SwiftUI

class PersonNotificationsPermissionInfoBlockViewModel: ObservableObject {

  private let localNotificationsManager = LocalNotificationsManager.shared
  private let appSettings = AppSettingsManager()

  @Binding var person: Person { didSet { setMessageAndVisibility() } }
  private var isNotificationsDisabledInAppSettings = false { didSet { setMessageAndVisibility() } }
  private var isNotificationsDenied = false { didSet { setMessageAndVisibility() } }

  @Published var isBlockHidden = true
  @Published var message = Messages.notificationsForUserDisabled.rawValue

  init(person: Binding<Person>) {
    _person = person
  }

  func checkIsBlockHidden() async {
    let isDenied = await localNotificationsManager.checkAuthorizationStatus() == .denied
    isNotificationsDenied = isDenied

    guard let notificationRules = appSettings.fetch()?.appNotificationRules else {
      return
    }

    let isNotificationOnEventDayEnabled = notificationRules.isNotificationOnEventDayEnabled
    let isNotificationOneDayBeforeEnabled = notificationRules.isNotificationOneDayBeforeEnabled
    let isNotificationOneWeekBeforeEnabled = notificationRules.isNotificationOneWeekBeforeEnabled

    isNotificationsDisabledInAppSettings = !isNotificationOnEventDayEnabled
      && !isNotificationOneDayBeforeEnabled
      && !isNotificationOneWeekBeforeEnabled

    setMessageAndVisibility()
  }

  private func setMessageAndVisibility() {
    let isBlockHidden = person.isNotificationsEnabled && !isNotificationsDisabledInAppSettings
      && !isNotificationsDenied

    setMessage()
    self.isBlockHidden = isBlockHidden
  }

  private enum Messages: String {
    // swiftlint:disable line_length
    case notificationsDenied =
      "To receive birthday notifications for your contacts, please enable notifications for the app in your device settings" // TODO: translate
    case notificationsDisabledInAppSettings =
      "You have disabled notification rules in the app settings. Adjust the settings to receive birthday reminders based on your preferences" // TODO: translate
    case notificationsForUserDisabled =
      "Notifications for this contact are currently disabled. Enable them in the profile settings to receive birthday reminders" // TODO: translate
    // swiftlint:enable line_length
  }

  private func setMessage() {
    switch true {
      case isNotificationsDenied:
        message = Messages.notificationsDenied.rawValue
      case isNotificationsDisabledInAppSettings:
        message = Messages.notificationsDisabledInAppSettings.rawValue
      case !person.isNotificationsEnabled:
        message = Messages.notificationsForUserDisabled.rawValue
      default:
        break
    }
  }

}
