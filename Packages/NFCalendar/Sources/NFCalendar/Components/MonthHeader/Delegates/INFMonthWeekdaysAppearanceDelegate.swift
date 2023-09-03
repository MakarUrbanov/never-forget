//
//  INFMonthWeekdaysAppearanceDelegate.swift
//
//
//  Created by Makar Mishchenko on 03.09.2023.
//

import UIKit


public protocol INFMonthWeekdaysAppearanceDelegate: AnyObject {
  /// Get label for weekday view
  /// - Parameters:
  ///   - weekdaysView: Weekday view instance
  ///   - weekday: Weekday short name with 2 characters
  /// - Returns: Label of certain weekday
  func weekdaysView(_ weekdaysView: INFMonthWeekdays, labelForWeekday weekday: String) -> UILabel?
}
