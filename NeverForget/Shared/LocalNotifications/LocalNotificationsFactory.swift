//
//  LocalNotificationsFactory.swift
//  NeverForgetApp
//
//  Created by makar on 5/3/23.
//

import Foundation
import NFLocalNotificationsManager

protocol LocalNotificationProtocol {
  func makeNFLNScheduledEventNotification() -> NFLNScheduledEventNotification
}

enum LocalNotificationsFactory {

  static func makeNotification(for type: NotificationsType) -> NFLNScheduledEventNotification {
    switch type {
      case .onBirthday(let birthdayNotificationData):
        return LocalNotificationForBirthday(
          type: birthdayNotificationData.type,
          personId: birthdayNotificationData.personId,
          identifier: birthdayNotificationData.identifier,
          username: birthdayNotificationData.username,
          date: birthdayNotificationData.date,
          image: birthdayNotificationData.imageData
        )
        .makeNFLNScheduledEventNotification()
    }
  }

}

extension LocalNotificationsFactory {

  struct BirthdayNotificationData {
    let type: LocalNotificationForBirthday.BirthdayNotificationType
    let personId: String
    let identifier: String
    let username: String
    let date: Date
    let imageData: Data?
  }

  enum NotificationsType {
    case onBirthday(BirthdayNotificationData)
  }

}
