//
//  NFCalendarViewModel.swift
//
//
//  Created by Makar Mishchenko on 02.09.2023.
//

import SwiftDate
import UIKit

// MARK: - Protocol
public protocol INFCalendarViewModel: AnyObject {
  var calendar: Calendar { get }

  func generateMonths() -> [Date]
  func numberOfWeeksInMonth(of date: Date) -> Int
}

// MARK: - NFCalendarViewModel
public final class NFCalendarViewModel: INFCalendarViewModel {
  public var calendar: Calendar = DateInRegion(region: .current).calendar

  // MARK: - Public methods
  public func generateMonths() -> [Date] {
    let startFrom = Self.renderFromDate.dateAtStartOf(.month)
    var months: [Date] = []

    for monthNumber in 0..<Self.numberOfRenderMonths {
      let monthDate = startFrom.dateByAdding(monthNumber, .month).date
      months.append(monthDate)
    }

    return months
  }

  public func numberOfWeeksInMonth(of date: Date) -> Int {
    date.dateAtEndOf(.month).weekOfMonth
  }
}

// MARK: - Static
extension NFCalendarViewModel {
  private static let renderFromDate: Date = .now
  private static let numberOfRenderMonths: Int = 12
}

// MARK: - Private methods
private extension NFCalendarViewModel {}
