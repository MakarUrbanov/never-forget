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
  func numberOfWeeksInMonth(of date: Date) -> Int
  func generateMonthsData() -> [NFMonthData]
}

// MARK: - NFCalendarViewModel
public final class NFCalendarViewModel: INFCalendarViewModel {
  // MARK: - Init
  public init() {}

  public func generateMonthsData() -> [NFMonthData] {
    let startFrom = Self.renderFromDate.dateAtStartOf(.month)
    var monthsData: [NFMonthData] = []

    for monthNumber in 0..<Self.numberOfRenderMonths {
      let firstMonthDate = startFrom.dateByAdding(monthNumber, .month).date
      let monthDates = Self.getMonthDays(from: firstMonthDate)
      let monthData: NFMonthData = .init(firstMonthDate: firstMonthDate, monthDates: monthDates)

      monthsData.append(monthData)
    }

    return monthsData
  }

  public func numberOfWeeksInMonth(of date: Date) -> Int {
    if let range = Self.calendar.range(of: .weekOfMonth, in: .month, for: date) {
      let numberOfWeeks = range.count

      return numberOfWeeks
    }

    fatalError("Something went wrong")
  }

}

// MARK: - Static
extension NFCalendarViewModel {
  private static let calendar = DateInRegion().calendar
  private static let renderFromDate: Date = .now
  private static let numberOfRenderMonths: Int = 12
}

// MARK: - Private methods
private extension NFCalendarViewModel {

  private static func getDaysCountInMonth(of date: Date) -> Int {
    date.in(region: .current).monthDays
  }

  private static func getFirstDateOfMonth(of date: Date) -> Date {
    date.dateAtStartOf(.month).date
  }

  private static func getMonthDays(from date: Date) -> [Date] {
    let daysInMonth = Self.getDaysCountInMonth(of: date)
    let firstDayOfMonth = Self.getFirstDateOfMonth(of: date)

    let systemFirstWeekday = Self.calendar.firstWeekday
    let weekdayOfFirstDay = Self.calendar.component(.weekday, from: firstDayOfMonth)
    let pastDatesShift: Int = (weekdayOfFirstDay - systemFirstWeekday + 7) % 7
    let startRenderFrom = firstDayOfMonth.dateByAdding(-pastDatesShift, .day).date
    let renderDatesCount = daysInMonth + pastDatesShift

    var daysList: [Date] = [startRenderFrom]

    for dayNumber in 0..<renderDatesCount - 1 {
      let newDate = startRenderFrom.dateByAdding(1 + dayNumber, .day).date
      daysList.append(newDate)
    }

    return daysList
  }

}
