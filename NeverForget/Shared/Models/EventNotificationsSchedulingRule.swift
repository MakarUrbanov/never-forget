//
//  EventNotificationsSchedulingRule.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 12.09.2023.
//

import Foundation

public enum EventNotificationsSchedulingRule: Int {
  /// Notifications disabled on this event
  case disabled = 1
  /// Notifications follows global app settings notification rules
  case globalSettings = 2
  /// Notifications follows custom rules from the event
  case customSettings = 3
}
