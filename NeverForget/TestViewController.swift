//
//  TestViewController.swift
//  NeverForgetApp
//
//  Created by Makar Mishchenko on 29.07.2023.
//

import NFCalendar
import SnapKit
import SwiftUI
import UIKit

class TestViewController: UIViewController {

  let calendar: INFCalendarView = NFCalendarView()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupCalendar()
  }

  private func setupCalendar() {
    calendar.calendarDataSource = self
    calendar.calendarAppearanceDelegate = self

    view.addSubview(calendar)

    calendar.snp.makeConstraints { make in
      make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
    }

    calendar.showsVerticalScrollIndicator = false

    calendar.renderCalendar()
  }

}

// MARK: - DataSource
extension TestViewController: INFCalendarDataSource {

  private static let dateFormatter = DateFormatter(dateFormat: DateFormatter.yearMonthDayFormat)

  private static func checkAndGetMarkedDate(_ date: Date) -> NFCalendarDay? {
    let dateString = dateFormatter.string(from: date)
    let markedDate = TestViewController.MOCK_DATA.first { markedDate in
      let markedDateString = dateFormatter.string(from: markedDate.date)

      return markedDateString == dateString
    }

    return markedDate
  }

  private static let MOCK_DATA: [NFCalendarDay] = {
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

  func calendarView(_ calendar: NFCalendarView, dataFor date: Date) -> NFCalendarDay? {
    if let markedDate = TestViewController.checkAndGetMarkedDate(date) {
      return markedDate
    }

    return .init(date: date)
  }

}

// MARK: - INFCalendarAppearanceDelegate
extension TestViewController: INFCalendarAppearanceDelegate {

  func calendarView(_ calendar: INFCalendarView, header: INFMonthHeader, labelForWeekday weekday: Int) -> UILabel? {
    if weekday == 1 || weekday == 7 {
      return CalendarWeekday.getWeekend()
    } else {
      return CalendarWeekday.getDefault1()
    }
  }

  func calendarView(_ calendar: INFCalendarView, header: INFMonthHeader, labelForMonth monthDate: Date) -> UILabel? {
    CalendarWeekday.getWeekend()
  }

  func calendarView(
    _ calendar: INFCalendarView,
    dayCell: INFDayCell,
    badgeLabelFor date: Date,
    badgeCount: Int?
  ) -> UILabel? {
    CalendarWeekday.getWeekend()
  }

  private final class CalendarWeekday: UILabel {

    static func getDefault1() -> UILabel {
      let label = UILabel()
      label.textAlignment = .center

      return label
    }

    static func getDefault() -> UILabel {
      let label = UILabel()
      label.textAlignment = .left
      label.textColor = .blue
      label.backgroundColor = .black

      return label
    }

    static func getWeekend() -> UILabel {
      let label = UILabel()
      label.textAlignment = .center
      label.textColor = .red

      return label
    }

  }

}

// struct TestView_Previews: PreviewProvider {
//  static var previews: some View {
//    TestViewController().makePreview()
//  }
// }
