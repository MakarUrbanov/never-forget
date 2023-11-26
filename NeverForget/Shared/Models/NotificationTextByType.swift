//
//  NotificationTextByType.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.11.2023.
//

import Foundation

enum NotificationTextByType {

  private static let optionTitles: [Event.NotificationsSchedulingRule: String] = [
    .globalSettings: String(localized: "General", comment: "General schedule notifications"),
    .customSettings: String(localized: "Custom", comment: "Custom schedule notifications"),
    .disabled: String(localized: "Don't send", comment: "Don't send notifications"),
  ]

  static func get(_ type: Event.NotificationsSchedulingRule) -> String {
    optionTitles[type]!
  }
}
