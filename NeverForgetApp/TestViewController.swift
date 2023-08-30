//
//  TestViewController.swift
//  NeverForgetApp
//
//  Created by Makar Mishchenko on 29.07.2023.
//

import NFCalendar
import SnapKit
import UIKit

class TestViewController: UIViewController {

  let calendar: NFCalendar = NFCalendarView()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupCalendar()
  }

  private func setupCalendar() {
    view.addSubview(calendar)

    calendar.calendarDataSource = self

    calendar.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    calendar.renderCalendar()
  }

}

extension TestViewController: NFCalendarDataSource {

  private static let dateFormatter = DateFormatter(dateFormat: DateFormatter.yearMonthDayFormat)

  private static func checkAndGetMarkedDate(_ date: Date) -> NFCalendarDayData? {
    let dateString = dateFormatter.string(from: date)
    let markedDate = TestViewController.MOCK_DATA.first { markedDate in
      let markedDateString = dateFormatter.string(from: markedDate.date)

      return markedDateString == dateString
    }

    return markedDate
  }

  private static let MOCK_DATA: [NFCalendarDayData] = {
    [
      .init(date: Date.now.addingTimeInterval(-36_000), backgroundImage: nil, badgeCount: 2),
      .init(date: Date.now, backgroundImage: UIImage(systemName: "person"), badgeCount: 1),
      .init(date: Date.now.addingTimeInterval(36_000), backgroundImage: nil, badgeCount: 3),
      .init(
        date: Date.now.addingTimeInterval(100_000),
        backgroundImage: UIImage(systemName: "apple.fill"),
        badgeCount: 15
      )
    ]
  }()

  func calendar(_ calendar: NFCalendar, dataFor date: Date) -> NFCalendarDayData {
    if let markedDate = TestViewController.checkAndGetMarkedDate(date) {
      return markedDate
    }

    return .init(date: date)
  }

}
