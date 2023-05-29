//
//  PersonsTableSections.swift
//  NeverForgetApp
//
//  Created by makar on 5/21/23.
//

import Foundation

enum PersonsTableSections: Hashable {
  case today
  case tomorrow
  case thisWeek
  case nextWeek

  case date(month: Int, year: Int)


  private static let dateFormatter = DateFormatter(dateFormat: "LLLL")

  var description: String { // TODO: translate
    switch self {
      case .today:
        return "Today"
      case .tomorrow:
        return "Tomorrow"
      case .thisWeek:
        return "This week"
      case .nextWeek:
        return "Next week"

      case .date(let month, let year) where month < 13 && month > 0:
        let isWithinCurrentYear = Calendar.current.component(.year, from: Date.now) == year
        let localizedMonth = PersonsTableSections.getLocalizedMonthDescription(month)

        return (
          isWithinCurrentYear
            ? localizedMonth
            : "\(localizedMonth) \(year)"
        ).capitalizeFirst()

      default:
        fatalError("Probably the month number is wrong")
    }
  }

  private static func getLocalizedMonthDescription(_ monthNumber: Int) -> String {
    let dateComponents = DateComponents(month: monthNumber)
    // swiftlint:disable:next force_unwrapping
    let date = Calendar.current.date(from: dateComponents)!
    let monthName = dateFormatter.string(from: date)

    return monthName
  }

  var referenceNumber: Int {
    switch self {
      case .today:
        return 0
      case .tomorrow:
        return 1
      case .thisWeek:
        return 2
      case .nextWeek:
        return 3
      case .date(month: let month, year: let year):
        return (year * 12) + month
    }
  }

}
