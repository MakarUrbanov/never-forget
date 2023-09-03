//
//  DateFormat+string.swift
//
//
//  Created by Makar Mishchenko on 18.08.2023.
//

import Foundation

public extension DateFormatter {

  // MARK: - Static properties
  static let yearMonthDayFormat = "YYYY-MM-dd"

  // MARK: - Initialize
  convenience init(dateFormat: String) {
    self.init()

    self.dateFormat = dateFormat
  }

  // MARK: - Static methods
  static func string(dateFormat: String, from date: Date) -> String {
    let formatter = self.init()
    formatter.dateFormat = dateFormat

    return formatter.string(from: date)
  }
}
