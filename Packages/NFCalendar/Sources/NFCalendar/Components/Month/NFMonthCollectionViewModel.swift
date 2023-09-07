//
//  NFMonthCollectionViewModel.swift
//
//
//  Created by Makar Mishchenko on 06.09.2023.
//

import Foundation
import NFCore
import SwiftDate

public protocol INFMonthCollectionViewModel: AnyObject {
  var firstMonthDate: Observable<Date>? { get set }
  var dates: Observable<[Date]> { get set }

  func getListOfPastAndFutureDatesOfMonth(dates: [Date], firstMonthsDate: Date) -> [Date]
  func areDatesInSameMonthAndYear(date1: Date, date2: Date) -> Bool
}

public class NFMonthCollectionViewModel: INFMonthCollectionViewModel {
  // MARK: - Public properties
  public var firstMonthDate: Observable<Date>?
  public var dates: Observable<[Date]> = Observable([])

  // MARK: - Public methods
  public func areDatesInSameMonthAndYear(date1: Date, date2: Date) -> Bool {
    date1.compare(.isSameMonth(date2))
  }

  public func getListOfPastAndFutureDatesOfMonth(dates: [Date], firstMonthsDate: Date) -> [Date] {
    let systemFirstWeekday = Self.calendar.firstWeekday

    let weekdayOfFirstDay = Self.calendar.component(.weekday, from: firstMonthsDate)
    let pastDatesShift: Int = (weekdayOfFirstDay - systemFirstWeekday + 7) % 7
    let pastDates: [Date] = (0..<pastDatesShift).reversed().compactMap {
      Self.calendar.date(byAdding: .day, value: -$0 - 1, to: firstMonthsDate)
    }

    return pastDates + dates
  }
}

// MARK: - Static
extension NFMonthCollectionViewModel {
  private static let calendar = DateInRegion().calendar
}
