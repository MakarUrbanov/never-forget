//
//  LocalNotificationDeepLinks.swift
//  NeverForgetApp
//
//  Created by makar on 5/8/23.
//

import Foundation
import NFLocalNotificationsManager

// TODO: mmk rework. so bad....
enum LocalNotificationDeepLinks {

  enum Components: String {
    case mainFlow

    case contactsListScreen
    case mainScreen
    case settingsScreen

    case personProfile
  }

  static func makeToPersonProfile(personId: String) -> NFLNDeepLink {
    NFLNDeepLink(
      link: URL(deepLinkComponents: [.mainFlow, .mainScreen, .personProfile]),
      providedData: ["personId": personId]
    )
  }
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

  func getDeepLinkComponents() -> [LocalNotificationDeepLinks.Components]? {
    var deepLinkComponents: [LocalNotificationDeepLinks.Components] = []

    for component in pathComponents {
      if let deepLinkComponent = LocalNotificationDeepLinks.Components(rawValue: component) {
        deepLinkComponents.append(deepLinkComponent)
      } else {
        return nil
      }
    }

    return deepLinkComponents
  }

}
