//
//  NotificationsSchedulingMenu.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 16.10.2023.
//

import UIKit

enum NotificationsSchedulingMenu {

  typealias MenuItem = TitledMenuButton.MenuItem

  static let menuConfiguration = TitledMenuButton.Configuration(
    title: "",
    preferredElementSize: .medium,
    elements: NotificationsSchedulingMenu.menuItems
  )

  static let menuItemsByEventRule: [Event.NotificationsSchedulingRule: MenuItem] = {
    let generalTitle = String(localized: "General", comment: "General schedule notifications")
    let customTitle = String(localized: "Custom", comment: "Custom schedule notifications")
    let dontSendTitle = String(localized: "Don't send", comment: "Don't send notifications")

    return [
      .globalSettings: MenuItem(identifier: 0, title: generalTitle),
      .customSettings: MenuItem(identifier: 1, title: customTitle),
      .disabled: MenuItem(identifier: 2, title: dontSendTitle)
    ]
  }()

  static let menuItems: [MenuItem] = {
    Array(menuItemsByEventRule.values)
  }()

  static func defineInitialMenuItem(notificationsSchedulingRule: Event.NotificationsSchedulingRule) -> MenuItem {
    guard let initialMenuItem = menuItemsByEventRule[notificationsSchedulingRule] else {
      fatalError("Necessary add new key by rule") // TODO: mmk add Logger
    }

    return initialMenuItem
  }

}
