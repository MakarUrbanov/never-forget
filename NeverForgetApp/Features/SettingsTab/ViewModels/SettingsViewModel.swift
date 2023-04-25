//
//  SettingsViewModel.swift
//  NeverForgetApp
//
//  Created by makar on 4/25/23.
//

import CoreData
import SwiftUI

final class SettingsViewModel: ObservableObject {
  private let appSettingsManager: AppSettingsManager

  @Published var localAppSettings = AppSettingsAdapter(appNotificationRules: AppNotificationRulesAdapter()) {
    didSet { saveSettings() }
  }

  init() {
    appSettingsManager = AppSettingsManager()
    appSettingsManager.delegate = self
    appSettingsManager.fetch()
  }

  func saveSettings() {
    let newSettings = localAppSettings.getAppSettings(in: AppSettingsManager.context)
    appSettingsManager.updateSettings(newSettings)
  }

}

// MARK: - AppSettingsManagerDelegate

extension SettingsViewModel: AppSettingsManagerDelegate {

  func settingsFetched(_ settings: AppSettings?) {
    guard let newSettings = settings else { return }
    localAppSettings.updateAppSettings(newSettings)
  }

}

// MARK: - Entity adapters

extension SettingsViewModel {

  struct AppNotificationTimeAdapter: Hashable {
    var hours: Int16 = 10
    var minutes: Int16 = 10

    func getAppNotificationTime(in context: NSManagedObjectContext) -> AppNotificationTime {
      let entity = AppNotificationTime(context: context)
      entity.hours = hours
      entity.minutes = minutes

      return entity
    }
  }

  struct AppNotificationRulesAdapter {
    var isNotificationOneDayBeforeEnabled = true
    var isNotificationOnEventDayEnabled = true
    var isNotificationOneWeekBeforeEnabled = true
    var onEventDayTimes: Set<AppNotificationTimeAdapter> = []

    private mutating func updateOnEventDayTimes(_ newTimes: NSSet) {
      let newTimes = newTimes.compactMap { time in
        if let time = time as? AppNotificationTime {
          let localTime = AppNotificationTimeAdapter(hours: time.hours, minutes: time.minutes)
          return localTime
        }

        return nil
      }

      onEventDayTimes = Set(newTimes)
    }

    mutating func updateNotificationRules(_ newRules: AppNotificationRules) {
      isNotificationOnEventDayEnabled = newRules.isNotificationOnEventDayEnabled
      isNotificationOneDayBeforeEnabled = newRules.isNotificationOneDayBeforeEnabled
      isNotificationOneWeekBeforeEnabled = newRules.isNotificationOneWeekBeforeEnabled

      if let newOnEventDayTimes = newRules.onEventDayTimes {
        updateOnEventDayTimes(newOnEventDayTimes)
      }
    }

    func getAppNotificationRules(in context: NSManagedObjectContext) -> AppNotificationRules {
      let rules = AppNotificationRules(context: context)
      rules.isNotificationOnEventDayEnabled = isNotificationOnEventDayEnabled
      rules.isNotificationOneDayBeforeEnabled = isNotificationOneDayBeforeEnabled
      rules.isNotificationOneWeekBeforeEnabled = isNotificationOneWeekBeforeEnabled
      rules.onEventDayTimes = NSSet(array: onEventDayTimes.map { $0.getAppNotificationTime(in: context) })
      return rules
    }

  }

  struct AppSettingsAdapter {
    var appNotificationRules: AppNotificationRulesAdapter

    func getAppSettings(in context: NSManagedObjectContext) -> AppSettings {
      let convertedSettings = AppSettings(context: context)
      convertedSettings.appNotificationRules = appNotificationRules.getAppNotificationRules(in: context)
      return convertedSettings
    }

    mutating func updateAppSettings(_ newSettings: AppSettings) {
      if let newNotificationRules = newSettings.appNotificationRules {
        appNotificationRules.updateNotificationRules(newNotificationRules)
      }
    }

  }

}
