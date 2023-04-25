//
//  AppSettingsManager.swift
//  NeverForgetApp
//
//  Created by makar on 4/24/23.
//

import Foundation

protocol AppSettingsManagerDelegate: AnyObject {
  func settingsFetched(_ settings: AppSettings?)
}

final class AppSettingsManager: ObservableObject {

  static let context = PersistentContainerProvider.shared.viewContext
  weak var delegate: AppSettingsManagerDelegate?

  @Published var settings: AppSettings?

  func fetch() {
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
      } else {
        settings = AppSettings(context: AppSettingsManager.context)
        settings?.appNotificationRules = getInitializedAppNotificationRules()
      }
    } catch {
      Logger.error(prefix: "Error loading settings from Core Data")
    }

    save()
    delegate?.settingsFetched(settings)
  }

  func save() {
    AppSettingsManager.context.saveSafely()
  }

  func updateSettings(_ newSettings: AppSettings) {
    settings?.appNotificationRules = newSettings.appNotificationRules
    save()
  }

}


extension AppSettingsManager {

  private func getInitializedAppNotificationRules() -> AppNotificationRules {
    let appNotificationRules = AppNotificationRules(context: AppSettingsManager.context)
    appNotificationRules.onEventDayTimes = []
    return appNotificationRules
  }

}
