//
//  LocalNotificationDeepLinks.swift
//  NeverForgetApp
//
//  Created by makar on 5/8/23.
//

import Foundation
import NFLocalNotificationsManager

enum LocalNotificationDeepLinks {

  enum Components: String {
    case mainFlow
    case personProfile
  }

  static let personProfile: NFLNDeepLink = .init(
    link: URL(deepLinkComponents: [.mainFlow, .personProfile]),
    providedData: [:]
  )
}

extension URL {
  init(deepLinkComponents: [LocalNotificationDeepLinks.Components]) {
    let link = deepLinkComponents.reduce("") { partialResult, component in
      partialResult.isEmpty
        ? "\(component.rawValue)"
        : "\(partialResult)/\(component.rawValue)"
    }

    // swiftlint:disable:next force_unwrapping
    self.init(string: link)!
  }
}
