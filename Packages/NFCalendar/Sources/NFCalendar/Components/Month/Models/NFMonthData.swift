//
//  NFMonthData.swift
//
//
//  Created by Makar Mishchenko on 07.09.2023.
//

import Foundation

public struct NFMonthData: Hashable {
  // MARK: - Public properties
  public var firstMonthDate: Date
  public var monthDates: [Date]

  // MARK: - Init
  public init(firstMonthDate: Date, monthDates: [Date]) {
    self.firstMonthDate = firstMonthDate
    self.monthDates = monthDates
  }
}
