//
//  LocalNotification.swift
//  NeverForgetApp
//
//  Created by makar on 5/1/23.
//

import Foundation
import NFLocalNotificationsManager

struct LocalNotification {
  let userId: String
  let date: Date

  var identifier: String {
    generateIdentifier()
  }

  let title: String
  let body: String
  let deepLink: NFLNDeepLink?
  let categoryIdentifier: NotificationsCategoryIdentifiers?

  private func generateIdentifier() -> String {
    let calendar = Calendar.current
    let month = calendar.component(.month, from: date)
    let day = calendar.component(.day, from: date)
    let hour = calendar.component(.hour, from: date)
    let minute = calendar.component(.minute, from: date)

    return "\(userId)-\(month)-\(day)-\(hour)-\(minute)"
  }
}
