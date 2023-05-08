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
  private let personsNotificationsManager = ContactNotificationsManager()

  private let saveSettingsDebouncer = Debouncer(delay: 0.8)

  @Published var localAppSettings = AppSettingsAdapter(appNotificationRules: AppNotificationRulesAdapter()) {
    didSet { saveSettings() }
  }

  init() {
    appSettingsManager = AppSettingsManager()
    appSettingsManager.delegate = self
    appSettingsManager.fetch()
  }

  func saveSettings() {
    saveSettingsDebouncer.perform { [weak self] in
      guard let self else { return }

      let newSettings = self.localAppSettings.getAppSettings(in: AppSettingsManager.context)
      self.appSettingsManager.updateSettings(newSettings)

      Task {
        await self.reschedulingAllPersonsNotifications()
      }
    }
  }

  func addNewOnEventDayTime() {
    if localAppSettings.appNotificationRules.onEventDayTimes.isEmpty {
      let newTime = AppNotificationTimeAdapter()
      localAppSettings.appNotificationRules.onEventDayTimes.append(newTime)
    } else {
      let maximalTime = localAppSettings.appNotificationRules.onEventDayTimes.reduce(0) { partialResult, time in
        if partialResult < time.fullMinutes {
          return Int(time.fullMinutes)
        }

        return partialResult
      }

      let hours = maximalTime / 60 + 1
      let minutes = maximalTime % 60
      let newTime = AppNotificationTimeAdapter(hours: Int16(hours), minutes: Int16(minutes))

      localAppSettings.appNotificationRules.onEventDayTimes.append(newTime)
    }
  }

  func deleteOnEventDayTime(_ indexSet: IndexSet) {
    localAppSettings.appNotificationRules.removeOnEventDayTime(indexSet)
    saveSettings()
  }

  func sortOnEventDayTimes() {
    localAppSettings.appNotificationRules.sortOnEventDayTimes()
  }

  func filterOnEventDayTimes() {
    let filtered = localAppSettings.appNotificationRules.getFilteredOnEventDayTimes()
    localAppSettings.appNotificationRules.onEventDayTimes = filtered
  }

}

// MARK: - AppSettingsManagerDelegate

extension SettingsViewModel: AppSettingsManagerDelegate {

  func settingsFetched(_ settings: AppSettings?) {
    guard let newSettings = settings else { return }
    localAppSettings.setAppSettings(newSettings)
  }

}

// MARK: - Notifications

extension SettingsViewModel {

  private func reschedulingAllPersonsNotifications() async {
    do {
      try await personsNotificationsManager.rescheduleNotificationsToAllPersons()
    } catch {
      Logger.error(message: "Error when rescheduling of the all persons notifications", error)
    }
  }

}

// MARK: - Entity adapters

extension SettingsViewModel {

  struct AppNotificationTimeAdapter: Hashable, Identifiable {
    let id = UUID().uuidString

    var date: Date
    var hours: Int { Calendar.current.component(.hour, from: date) }
    var minutes: Int { Calendar.current.component(.minute, from: date) }
    var fullMinutes: Int { Int(hours * 60 + minutes) }

    init(hours: Int16 = 10, minutes: Int16 = 0) {
      let correctHours = hours == 24 ? 0 : hours

      date = Calendar.current
        .date(bySettingHour: Int(correctHours), minute: Int(minutes), second: 0, of: Date.now) ?? Date.now
    }

    mutating func setDate(_ date: Date) {
      self.date = date
    }

    func getAppNotificationTime(in context: NSManagedObjectContext) -> AppNotificationTime {
      let entity = AppNotificationTime(context: context)
      entity.hours = Int16(hours)
      entity.minutes = Int16(minutes)

      return entity
    }

  }

  struct AppNotificationRulesAdapter {
    var isNotificationOneDayBeforeEnabled = true
    var isNotificationOnEventDayEnabled = true
    var isNotificationOneWeekBeforeEnabled = true

    var timeOnOneWeekBefore: AppNotificationTimeAdapter = .init()
    var timeOnOneDayBefore: AppNotificationTimeAdapter = .init()
    var onEventDayTimes: [AppNotificationTimeAdapter] = []

    private mutating func setOnEventDayTimes(_ newTimes: NSSet) {
      let newTimes: [AppNotificationTimeAdapter] = newTimes.compactMap { time in
        if let time = time as? AppNotificationTime {
          return AppNotificationRulesAdapter.convertAppTime(time)
        }

        return nil
      }
      .sorted(by: SettingsViewModel.sortOnEventDayTimes)

      onEventDayTimes = newTimes
    }

    mutating func setNotificationRules(_ newRules: AppNotificationRules) {
      isNotificationOnEventDayEnabled = newRules.isNotificationOnEventDayEnabled
      isNotificationOneDayBeforeEnabled = newRules.isNotificationOneDayBeforeEnabled
      isNotificationOneWeekBeforeEnabled = newRules.isNotificationOneWeekBeforeEnabled

      timeOnOneWeekBefore = AppNotificationRulesAdapter.convertAppTime(newRules.timeOnOneWeekBefore)
      timeOnOneDayBefore = AppNotificationRulesAdapter.convertAppTime(newRules.timeOnOneDayBefore)

      if let newOnEventDayTimes = newRules.onEventDayTimes {
        setOnEventDayTimes(newOnEventDayTimes)
      }
    }

    func getAppNotificationRules(in context: NSManagedObjectContext) -> AppNotificationRules {
      let rules = AppNotificationRules(context: context)
      rules.isNotificationOnEventDayEnabled = isNotificationOnEventDayEnabled
      rules.isNotificationOneDayBeforeEnabled = isNotificationOneDayBeforeEnabled
      rules.isNotificationOneWeekBeforeEnabled = isNotificationOneWeekBeforeEnabled
      rules.timeOnOneWeekBefore = AppNotificationRulesAdapter.convertToAppTime(timeOnOneWeekBefore, in: context)
      rules.timeOnOneDayBefore = AppNotificationRulesAdapter.convertToAppTime(timeOnOneDayBefore, in: context)

      let filteredTimes = getFilteredOnEventDayTimes()
      rules.onEventDayTimes = NSSet(array: filteredTimes.map { $0.getAppNotificationTime(in: context) })

      return rules
    }

    mutating func removeOnEventDayTime(_ indexSet: IndexSet) {
      onEventDayTimes.remove(atOffsets: indexSet)
    }

    mutating func sortOnEventDayTimes() {
      onEventDayTimes.sort(by: SettingsViewModel.sortOnEventDayTimes)
    }

    func getFilteredOnEventDayTimes() -> [AppNotificationTimeAdapter] {
      onEventDayTimes.reduce(into: [AppNotificationTimeAdapter]()) { partialResult, time in
        if !partialResult.contains(where: { $0.fullMinutes == time.fullMinutes }) {
          return partialResult += [time]
        }
      }
    }

    private static func convertAppTime(_ time: AppNotificationTime?) -> AppNotificationTimeAdapter {
      AppNotificationTimeAdapter(hours: time?.hours ?? 10, minutes: time?.minutes ?? 0)
    }

    private static func convertToAppTime(
      _ time: AppNotificationTimeAdapter,
      in context: NSManagedObjectContext
    ) -> AppNotificationTime {
      let appTime = AppNotificationTime(context: context)
      appTime.hours = Int16(time.hours)
      appTime.minutes = Int16(time.minutes)

      return appTime
    }

  }

  struct AppSettingsAdapter {
    var appNotificationRules: AppNotificationRulesAdapter

    func getAppSettings(in context: NSManagedObjectContext) -> AppSettings {
      let convertedSettings = AppSettings(context: context)
      convertedSettings.appNotificationRules = appNotificationRules.getAppNotificationRules(in: context)
      return convertedSettings
    }

    mutating func setAppSettings(_ newSettings: AppSettings) {
      if let newNotificationRules = newSettings.appNotificationRules {
        appNotificationRules.setNotificationRules(newNotificationRules)
      }
    }

  }

}

// MARK: - Utils

extension SettingsViewModel {

  private static let sortOnEventDayTimes: (AppNotificationTimeAdapter, AppNotificationTimeAdapter)
    -> Bool = { lhs, rhs in
      (lhs.hours * 60 + lhs.minutes) < (rhs.hours * 60 + rhs.minutes)
    }

}
