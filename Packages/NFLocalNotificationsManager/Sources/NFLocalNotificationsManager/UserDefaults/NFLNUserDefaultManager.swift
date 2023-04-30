//
//  NFLNUserDefaultManager.swift
//
//
//  Created by makar on 4/30/23.
//

import Foundation

public final class NFLNUserDefaultManager {
  private let userDefaults = UserDefaults(suiteName: "NFLocalNotificationsManager") ?? UserDefaults.standard

  public func getBool(_ key: Keys) -> Bool {
    userDefaults.bool(forKey: key.rawValue)
  }

  public func setBool(_ value: Bool, key: Keys) {
    userDefaults.setValue(value, forKey: key.rawValue)
  }

}

public extension NFLNUserDefaultManager {

  enum Keys: String {
    case isAuthorized
    case isDenied
  }

}
