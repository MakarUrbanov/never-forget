//
//  EventsCalendarViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

import NFCalendar
import SwiftDate
import UIKit

protocol IEventsCalendarView: UIViewController {
  func didChangeEvents()
}

class EventsCalendarViewController: UIViewController, IEventsCalendarView {

  var presenter: IEventsCalendarPresenter?

  let calendarView: INFCalendarView = NFCalendarView(viewModel: NFCalendarViewModel())

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter?.viewDidLoad()

    view.backgroundColor = .clear
    initialize()
  }

  func didChangeEvents() {}

}

// MARK: - Initialize UI
private extension EventsCalendarViewController {

  private func initialize() {
    setupCalendar()
  }

  private func setupCalendar() {
    calendarView.showsVerticalScrollIndicator = false
    calendarView.backgroundColor = .clear
    calendarView.separatorColor = UIColor(resource: .textLight100).withAlphaComponent(0.04)

    calendarView.calendarDataSource = self
    calendarView.calendarAppearanceDelegate = self
    calendarView.calendarDelegate = self

    view.addSubview(calendarView)

    calendarView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }

    calendarView.renderCalendar()
  }

}

// MARK: - DataSource
extension EventsCalendarViewController: INFCalendarDataSource {

  private static let dateFormatter = DateFormatter(dateFormat: DateFormatter.yearMonthDayFormat)

  private static func checkAndGetMarkedDate(_ date: Date) -> NFCalendarDay? {
    let dateString = dateFormatter.string(from: date)
    var markedDate = Self.MOCK_DATA.first { markedDate in
      let markedDateString = dateFormatter.string(from: markedDate.date)

      return markedDateString == dateString
    }

    markedDate?.date = date

    return markedDate
  }

  private static let MOCK_DATA: [NFCalendarDay] = {
    [
      .init(
        date: DateInRegion().dateByAdding(-2, .day).date,
        backgroundImage: UIImage(named: "mockImage2"),
        badgeCount: 1
      ),
      .init(
        date: DateInRegion().date,
        backgroundImage: UIImage(named: "mockImage2"),
        badgeCount: 3
      ),
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
      ),
    ]
  }()

  func calendarView(_ calendar: NFCalendarView, dataFor date: Date) -> NFCalendarDay? {
    if let markedDate = Self.checkAndGetMarkedDate(date) {
      return markedDate
    }

    return .init(date: date)
  }

}

// MARK: - UI calendar helpers
private extension EventsCalendarViewController {

  private static func isDateToday(_ date: Date) -> Bool {
    date.in(region: .local).compare(.isToday)
  }

  private static func isDateEarlierToday(date: Date) -> Bool {
    date.in(region: .local).compare(.isEarlier(than: DateInRegion()))
  }

  private static func defineWhatTimeTheDate(_ date: Date) -> NFDayType {
    let isTodayDate = Self.isDateToday(date)
    if isTodayDate {
      return .todayDate
    }

    let isPastDay = Self.isDateEarlierToday(date: date)
    if isPastDay {
      return .pastDate
    }

    return .defaultDate
  }

  private func defineTypeOfDay(_ date: Date) -> NFDayType {
    if Self.checkAndGetMarkedDate(date) != nil {
      let dateTime = Self.defineWhatTimeTheDate(date)
      return .dateWithEvents(dateTime)
    }

    return Self.defineWhatTimeTheDate(date)
  }

}

// MARK: - INFCalendarAppearanceDelegate
extension EventsCalendarViewController: INFCalendarAppearanceDelegate {

  func calendarView(_ calendar: INFCalendarView, minimumLineSpacingForSectionAt: Int) -> CGFloat? {
    20
  }

  func dayCellComponents(_ dayCell: INFDayCell) -> NFDayComponents? {
    NFDayComponents(
      dateLabel: DateLabel.self,
      dateBadgeLabel: DateBadgeLabel.self,
      dateBackgroundImage: DateBackgroundImageView.self
    )
  }

  func dayCell(_ dayCell: INFDayCell, setupDateLabel label: INFDayLabel, ofDate date: Date) {
    let dayType = defineTypeOfDay(date)
    label.setDayType(dayType)
  }

  func dayCell(_ dayCell: INFDayCell, setupBadgeLabel label: INFDayBadgeLabel, ofDate date: Date, badgeCount: Int?) {
    let dayType = defineTypeOfDay(date)
    label.setDayType(dayType)
  }

  func dayCell(
    _ dayCell: INFDayCell,
    setupBackgroundImage imageView: INFDayBackgroundImageView,
    ofDate date: Date,
    image: UIImage?
  ) {
    let dayType = defineTypeOfDay(date)
    imageView.setDayType(dayType)
  }

  // TODO: mmk rework like dates
  func monthHeader(_ header: INFMonthHeader, weekdaysView: INFMonthWeekdays, labelForWeekday weekday: Int) -> UILabel? {
    CalendarWeekday.getDefault()
  }

  // TODO: mmk rework like dates
  func monthHeader(_ header: INFMonthHeader, labelForMonth monthDate: Date) -> UILabel? {
    MonthTitle.getDefault()
  }

}

// MARK: - INFCalendarDelegate
extension EventsCalendarViewController: INFCalendarDelegate {

  func calendar(_ calendar: NFCalendarView, didSelect date: Date) {
    // TODO: mmk remove test impl
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 2
    let text = "You selected \(date.toFormat("yyyy MM dd"))"
    let markedDate = Self.checkAndGetMarkedDate(date)
    let description = "Events: \(markedDate?.badgeCount ?? 0)"
    label.text = "\(text)\n\(description)"

    let viewController = UIViewController()
    viewController.view.backgroundColor = UIColor(resource: .darkBackground)
    viewController.view.addSubview(label)
    label.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    navigationController?.present(viewController, animated: true)
  }

}

// MARK: - App UI
private extension EventsCalendarViewController {

  // MARK: - MonthTitle
  private final class MonthTitle: UILabel {

    static func getDefault() -> UILabel {
      let label = MonthTitle()
      label.font = UIFont.systemFont(.subheadline, .regular)
      label.textAlignment = .center
      label.textColor = UIColor(resource: .textLight100)

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
      label.textColor = UIColor(resource: .textLight30)

      return label
    }

  }


  // MARK: - DateLabel
  private class DateLabel: UILabel, INFDayLabel {

    var dayType: NFCalendar.NFDayType = .defaultDate

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

    func setDayType(_ dayType: NFCalendar.NFDayType) {
      self.dayType = dayType

      switch dayType {
        case .pastDate:
          setPastDate()
        case .todayDate:
          setTodayDate()
        case .defaultDate:
          setDefaultDate()
        case .dateWithEvents(let time):
          setDateWithEvents(in: time)
      }
    }

    private func resetCommonSettings() {
      layer.borderWidth = 0
      layer.borderColor = UIColor.clear.cgColor
      backgroundColor = .clear
    }

    private func setDefaultDate() {
      resetCommonSettings()

      textColor = UIColor(resource: .textLight100)
    }

    private func setPastDate() {
      resetCommonSettings()

      textColor = UIColor(resource: .textLight30)
    }

    private func setTodayDate() {
      resetCommonSettings()

      textColor = UIColor(resource: .textLight100)
      backgroundColor = UIColor(resource: .main100)
    }

    private func setDateWithEvents(in time: NFDayType) {
      resetCommonSettings()

      if time == .pastDate {
        textColor = UIColor(resource: .textLight30)
        layer.borderWidth = 1
        layer.borderColor = UIColor(resource: .textLight30).cgColor
      } else if time == .todayDate {
        textColor = UIColor(resource: .textLight100)
        backgroundColor = UIColor(resource: .main100)
        layer.borderWidth = 1
        layer.borderColor = UIColor(resource: .textLight100).cgColor
      } else {
        textColor = UIColor(resource: .textLight100)
        layer.borderWidth = 1
        layer.borderColor = UIColor(resource: .textLight100).cgColor
      }
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
  private class DateBadgeLabel: UILabel, INFDayBadgeLabel {

    var dayType: NFCalendar.NFDayType = .defaultDate

    required init() {
      super.init(frame: .zero)

      font = UIFont.systemFont(.footnote, .black)
      layer.zPosition = 2
      textAlignment = .center
      layer.masksToBounds = true

      backgroundColor = UIColor(resource: .textLight100)
      textColor = UIColor(resource: .darkBackground)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    private func resetCommonSettings() {
      backgroundColor = UIColor(resource: .textLight100)
    }

    func setDayType(_ dayType: NFCalendar.NFDayType) {
      self.dayType = dayType

      switch dayType {
        case .pastDate:
          setPastDate()
        case .todayDate:
          setTodayDate()
        case .defaultDate:
          setDefaultDate()
        case .dateWithEvents(let time):
          setDateWithEvents(in: time)
      }
    }

    private func setDefaultDate() {
      resetCommonSettings()
    }

    private func setPastDate() {
      resetCommonSettings()

      backgroundColor = UIColor(resource: .textLight30)
    }

    private func setDateWithEvents(in time: NFDayType) {
      resetCommonSettings()

      if time == .pastDate {
        backgroundColor = UIColor(resource: .textLight30)
      }
    }

    private func setTodayDate() {
      resetCommonSettings()
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
  private class DateBackgroundImageView: UIImageView, INFDayBackgroundImageView {

    var dayType: NFCalendar.NFDayType = .defaultDate

    private let darkLayer: CAShapeLayer = .init()

    required init() {
      super.init(frame: .zero)

      layer.zPosition = 0
      layer.masksToBounds = true
      contentMode = .scaleAspectFill

      darkLayer.fillColor = UIColor(resource: .darkBackground).withAlphaComponent(0.6).cgColor
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func setDayType(_ dayType: NFCalendar.NFDayType) {
      self.dayType = dayType

      switch dayType {
        case .pastDate:
          setPastDate()
        case .todayDate:
          setTodayDate()
        case .dateWithEvents(let time):
          setDateWithEvents(in: time)
        case .defaultDate:
          setDefaultDate()
      }
    }

    private func resetCommonSettings() {
      alpha = 1
      darkLayer.fillColor = UIColor(resource: .darkBackground).withAlphaComponent(0.6).cgColor
    }

    private func setDefaultDate() {
      resetCommonSettings()
    }

    private func setPastDate() {
      resetCommonSettings()
    }

    private func setTodayDate() {
      resetCommonSettings()
    }

    private func setDateWithEvents(in time: NFDayType) {
      resetCommonSettings()

      if time == .pastDate {
        darkLayer.fillColor = UIColor(resource: .darkBackground).withAlphaComponent(0.9).cgColor
      } else if time == .todayDate {
        alpha = 0
      }
    }

    override func layoutSubviews() {
      super.layoutSubviews()
      setCornerRadius()
      updateDarkLayer()
    }

    private func setCornerRadius() {
      let radius = bounds.width / 2
      layer.cornerRadius = radius
    }

    private func updateDarkLayer() {
      darkLayer.removeFromSuperlayer()
      let width = bounds.width
      let height = bounds.height
      darkLayer.path = UIBezierPath(
        roundedRect: .init(x: 0, y: 0, width: width, height: height),
        cornerRadius: 0
      ).cgPath
      darkLayer.zPosition = 1
      layer.addSublayer(darkLayer)
      layer.setNeedsDisplay()
    }
  }

}

import SwiftUI

#Preview {
  EventsCalendarViewController().makePreview()
}
