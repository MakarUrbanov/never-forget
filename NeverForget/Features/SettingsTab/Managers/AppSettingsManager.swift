//
//  AppSettingsManager.swift
//  NeverForgetApp
//
//  Created by makar on 4/24/23.
//

import Foundation

// MARK: Delegate

protocol AppSettingsManagerDelegate: AnyObject {
  func settingsFetched(_ settings: AppSettings?)
}

// MARK: Manager

final class AppSettingsManager: ObservableObject {

  static let context = CoreDataWrapper.shared.viewContext

  weak var delegate: AppSettingsManagerDelegate?

  @Published var settings: AppSettings?

  @discardableResult
  func fetch() -> AppSettings? {
    let fetchRequest = AppSettings.fetchRequest()
    fetchRequest.fetchLimit = 1

    do {
      let result = try AppSettingsManager.context.fetch(fetchRequest)

      if let appSettings = result.first {
        settings = appSettings

        // first set of the appNotificationRules
        if appSettings.appNotificationRules == nil {
          settings?.appNotificationRules = getInitializedAppNotificationRules()
        }

        let isNotificationTimesNil = appSettings.appNotificationRules?.onEventDayTimes == nil
        let isNotificationTimesEmpty = appSettings.appNotificationRules?.onEventDayTimes?.count == 0

        if isNotificationTimesNil || isNotificationTimesEmpty {
          settings?.appNotificationRules?.onEventDayTimes = [AppSettingsManager.getInitialOnEventDayTime()]
        }
      } else {
        settings = AppSettings(context: AppSettingsManager.context)
        settings?.appNotificationRules = getInitializedAppNotificationRules()
      }
    } catch {
      Logger.error(message: "Error loading settings from Core Data")
    }

    save()
    delegate?.settingsFetched(settings)

    return settings
  }

  func save() {
    AppSettingsManager.context.saveChanges()
  }

  func updateSettings(_ newSettings: AppSettings) {
    settings?.appNotificationRules = newSettings.appNotificationRules
    save()
  }

}

// MARK: Utils for initialization of the notification rules

extension AppSettingsManager {

  private static func getInitialOnEventDayTime() -> AppNotificationTime {
    let time = AppNotificationTime(context: AppSettingsManager.context)
    time.hours = 10
    time.minutes = 0
    return time
  }

  private func getInitializedAppNotificationRules() -> AppNotificationRules {
    let appNotificationRules = AppNotificationRules(context: AppSettingsManager.context)
    appNotificationRules.timeOnOneWeekBefore = AppSettingsManager.getInitialOnEventDayTime()
    appNotificationRules.timeOnOneDayBefore = AppSettingsManager.getInitialOnEventDayTime()
    appNotificationRules.onEventDayTimes = [AppSettingsManager.getInitialOnEventDayTime()]
    return appNotificationRules
  }

}
