//
//  TestViewController.swift
//  NeverForgetApp
//
//  Created by Makar Mishchenko on 29.07.2023.
//

import NFCalendar
import SnapKit
import SwiftDate
import SwiftUI
import UIKit

class TestViewController: UIViewController {

  let calendar: INFCalendarView = NFCalendarView()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor.Theme.darkBackground
    setupCalendar()
  }

  private func setupCalendar() {
    calendar.calendarDataSource = self
    calendar.calendarAppearanceDelegate = self
    calendar.calendarDelegate = self

    calendar.backgroundColor = .clear

    view.addSubview(calendar)

    calendar.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
      .init(
        date: DateInRegion().dateByAdding(2, .day).date,
        backgroundImage: nil,
        badgeCount: 3
      ),
      .init(
        date: DateInRegion().dateByAdding(3, .day).date,
        backgroundImage: UIImage(named: "mockImage2"),
        badgeCount: 2
      ),
      .init(
        date: DateInRegion().dateByAdding(5, .day).date,
        backgroundImage: UIImage(named: "MockImage"),
        badgeCount: 1
      ),
      .init(
        date: DateInRegion().dateByAdding(13, .day).dateByAdding(1, .month).date,
        backgroundImage: UIImage(named: "mockImage2"),
        badgeCount: 1
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

// MARK: - UI calendar helpers
private extension TestViewController {

  private static func compareDates(date1: Date, date2: Date) -> Bool {
    let dateFormat = DateFormatter.yearMonthDayFormat
    let day1String = DateFormatter.string(dateFormat: dateFormat, from: date1)
    let day2String = DateFormatter.string(dateFormat: dateFormat, from: date2)

    return day1String == day2String
  }

  private static func isDateToday(_ date: Date) -> Bool {
    TestViewController.compareDates(date1: Date.now, date2: date)
  }

  private static func isDateYesterdayOrEarlier(date: Date) -> Bool {
    guard let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) else {
      fatalError("Something went wrong")
    }

    return date < yesterday
  }

  private func defineTypeOfDay(_ date: Date) -> DayType {
    if TestViewController.checkAndGetMarkedDate(date) != nil {
      return .dateWithEvents
    }

    let isTodayDate = TestViewController.isDateToday(date)
    if isTodayDate {
      return .todayDate
    }

    let isPastDay = TestViewController.isDateYesterdayOrEarlier(date: date)
    if isPastDay {
      return .pastDate
    }

    return .defaultDate
  }

}

// MARK: - INFCalendarAppearanceDelegate
extension TestViewController: INFCalendarAppearanceDelegate {

  func calendarView(_ calendar: INFCalendarView, header: INFMonthHeader, labelForWeekday weekday: Int) -> UILabel? {
    CalendarWeekday.getDefault()
  }

  func calendarView(_ calendar: INFCalendarView, header: INFMonthHeader, labelForMonth monthDate: Date) -> UILabel? {
    MonthTitle.getDefault()
  }

  func calendarView(
    _ calendar: INFCalendarView,
    dayCell: INFDayCell,
    badgeLabelFor date: Date,
    badgeCount: Int?
  ) -> UILabel? {
    let dayType = defineTypeOfDay(date)

    switch dayType {
      case .pastDate:
        return DateBadgeLabel.pastDate()
      case .todayDate:
        return DateBadgeLabel.todayDate()
      default:
        return DateBadgeLabel.defaultDate()
    }
  }

  func calendarView(_ calendar: INFCalendarView, dayCell: INFDayCell, dateLabelFor date: Date) -> UILabel? {
    let dayType = defineTypeOfDay(date)

    switch dayType {
      case .pastDate:
        return DateLabel.pastDate()
      case .todayDate:
        return DateLabel.todayDate()
      case .defaultDate:
        return DateLabel.defaultDate()
      case .dateWithEvents:
        return DateLabel.dateWithEvents()
    }
  }

  func calendarView(
    _ calendar: INFCalendarView,
    dayCell: INFDayCell,
    backgroundImageFor date: Date,
    image: UIImage?
  ) -> UIImageView? {
    let dayType = defineTypeOfDay(date)

    switch dayType {
      case .pastDate:
        return DateBackgroundImageView.pastDate()
      case .todayDate:
        return DateBackgroundImageView.todayDate()
      default:
        return DateBackgroundImageView.defaultDate()
    }
  }

}

extension TestViewController: INFCalendarDelegate {

  func calendar(_ calendar: NFCalendarView, didSelect date: Date) {
    // TODO: mmk remove test impl
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 2
    let text = "You selected \(date.toFormat("yyyy MM dd"))"
    let markedDate = TestViewController.checkAndGetMarkedDate(date)
    let description = "Events: \(markedDate?.badgeCount ?? 0)"
    label.text = "\(text)\n\(description)"

    let viewController = UIViewController()
    viewController.view.backgroundColor = .Theme.darkBackground
    viewController.view.addSubview(label)
    label.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    navigationController?.present(viewController, animated: true)
  }

}

// MARK: - App UI
private extension TestViewController {

  // MARK: - MonthTitle
  private final class MonthTitle: UILabel {

    static func getDefault() -> UILabel {
      let label = MonthTitle()
      label.font = UIFont.systemFont(.subheadline, .regular)
      label.textAlignment = .center
      label.textColor = UIColor.Theme.textLight100

      return label
    }

  }

  // MARK: - CalendarWeekday
  private final class CalendarWeekday: UILabel {

    override init(frame: CGRect) {
      super.init(frame: frame)

      textAlignment = .center
      font = UIFont.systemFont(.body, .bold)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    static func getDefault() -> UILabel {
      let label = CalendarWeekday()
      label.textColor = UIColor.Theme.textLight30

      return label
    }

  }


  // MARK: - DateLabel
  private class DateLabel: UILabel, CustomizableCalendarDateComponent {

    required init() {
      super.init(frame: .zero)

      font = UIFont.systemFont(.body, .regular)
      layer.masksToBounds = true
      textAlignment = .center
      layer.zPosition = 1
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    static func defaultDate() -> Self {
      let label = self.init()

      label.textColor = UIColor.Theme.textLight100

      return label
    }

    static func pastDate() -> Self {
      let label = self.init()

      label.textColor = UIColor.Theme.textLight30

      return label
    }

    static func todayDate() -> Self {
      let label = self.init()

      label.textColor = UIColor.Theme.textLight100
      label.backgroundColor = UIColor.Theme.main100

      return label
    }

    static func dateWithEvents() -> Self {
      let label = self.init()

      label.textColor = UIColor.Theme.textLight100
      label.layer.borderWidth = 1
      label.layer.borderColor = UIColor.Theme.textLight100.cgColor

      return label
    }

    override func layoutSubviews() {
      super.layoutSubviews()
      setCornerRadius()
    }

    private func setCornerRadius() {
      let radius = bounds.width / 2
      layer.cornerRadius = radius
    }

  }

  // MARK: - DateBadgeLabel
  private class DateBadgeLabel: UILabel, CustomizableCalendarDateComponent {

    required init() {
      super.init(frame: .zero)

      font = UIFont.systemFont(.footnote, .black)
      layer.zPosition = 2
      textAlignment = .center
      layer.masksToBounds = true

      backgroundColor = UIColor.Theme.textLight100
      textColor = UIColor.Theme.darkBackground
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    static func defaultDate() -> Self {
      let label = self.init()

      return label
    }

    static func pastDate() -> Self {
      let label = self.init()

      return label
    }

    static func dateWithEvents() -> Self {
      let label = self.init()

      return label
    }

    static func todayDate() -> Self {
      let label = self.init()

      return label
    }

    override func layoutSubviews() {
      super.layoutSubviews()
      setCornerRadius()
    }

    private func setCornerRadius() {
      let radius = bounds.width / 2
      layer.cornerRadius = radius
    }

  }

  // MARK: - DateBackgroundImageView
  private class DateBackgroundImageView: UIImageView, CustomizableCalendarDateComponent {

    required init() {
      super.init(frame: .zero)

      layer.zPosition = 0
      layer.masksToBounds = true
      contentMode = .scaleAspectFill
      alpha = 0.6
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    static func pastDate() -> Self {
      let imageView = self.init()

      return imageView
    }

    static func todayDate() -> Self {
      let imageView = self.init()

      return imageView
    }

    static func dateWithEvents() -> Self {
      let imageView = self.init()

      return imageView
    }


    static func defaultDate() -> Self {
      let imageView = self.init()

      return imageView
    }

    override func layoutSubviews() {
      super.layoutSubviews()
      setCornerRadius()
    }

    private func setCornerRadius() {
      let radius = bounds.width / 2
      layer.cornerRadius = radius
    }
  }

}

// MARK: - Models
private extension TestViewController {

  private enum DayType {
    case pastDate
    case todayDate
    case defaultDate
    case dateWithEvents
  }

}

private protocol CustomizableCalendarDateComponent: UIView {
  static func pastDate() -> Self
  static func todayDate() -> Self
  static func defaultDate() -> Self
  static func dateWithEvents() -> Self
}

struct TestView_Previews: PreviewProvider {
  static var previews: some View {
    TestViewController().makePreview()
  }
}
