//
//  EventsCalendarViewController.swift
//  NeverForgetApp
//
//  Created by Makar Mishchenko on 29.07.2023.
//

import NFCalendar
import SnapKit
import SwiftDate
import SwiftUI
import UIKit

protocol IEventsCalendarViewController: UIViewController {
  var calendarView: INFCalendarView { get }
}

final class EventsCalendarViewController: UIViewController, IEventsCalendarViewController {

  let viewsSwitcher: IViewsSwitcherView = ViewsSwitcherView(buttons: [
    .init(text: String(localized: "Calendar"), index: 0),
    .init(text: String(localized: "List"), index: 1)
  ])

  let calendarView: INFCalendarView = NFCalendarView(viewModel: NFCalendarViewModel())

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(resource: .darkBackground)
    setupTESTSwitcher()
    setupCalendar()
  }

}

// MARK: - Private methods
extension EventsCalendarViewController {

  private func setupTESTSwitcher() {
    viewsSwitcher.backgroundColor = UIColor(resource: .textLight100).withAlphaComponent(0.08)
    viewsSwitcher.layer.cornerRadius = 12
    viewsSwitcher.delegate = self

    view.addSubview(viewsSwitcher)

    viewsSwitcher.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.height.equalTo(40)
    }
  }

  private func setupCalendar() {
    calendarView.showsVerticalScrollIndicator = false
    calendarView.backgroundColor = .clear

    calendarView.calendarDataSource = self
    calendarView.calendarAppearanceDelegate = self
    calendarView.calendarDelegate = self

    view.addSubview(calendarView)

    // TODO: mmk remove switcher dependency
    calendarView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(16)
      make.top.equalTo(viewsSwitcher.snp.bottom)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }

    calendarView.renderCalendar()
  }

}

// MARK: - IViewsSwitcherViewDelegate
extension EventsCalendarViewController: IViewsSwitcherViewDelegate {
  func viewsSwitcher(_ switcher: IViewsSwitcherView, didSelect button: SwitcherButtonData) {
    print("mmk SELECTED", button.text)
  }

  func viewsSwitcher(_ switcher: IViewsSwitcherView, didSelectSelected button: SwitcherButtonData) {
    print("mmk select already SELECTED", button.text)
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
      )
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

  private static func defineWhatTimeTheDate(_ date: Date) -> DayType {
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

  private func defineTypeOfDay(_ date: Date) -> DayType {
    if Self.checkAndGetMarkedDate(date) != nil {
      let dateTime = Self.defineWhatTimeTheDate(date)
      return .dateWithEvents(dateTime)
    }

    return Self.defineWhatTimeTheDate(date)
  }

}

// MARK: - INFCalendarAppearanceDelegate
extension EventsCalendarViewController: INFCalendarAppearanceDelegate {

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
      case .dateWithEvents(let time):
        return DateBadgeLabel.dateWithEvents(in: time)
      case .defaultDate:
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
      case .dateWithEvents(let time):
        return DateLabel.dateWithEvents(in: time)
      case .defaultDate:
        return DateLabel.defaultDate()
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
      case .dateWithEvents(let time):
        return DateBackgroundImageView.dateWithEvents(in: time)
      case .defaultDate:
        return DateBackgroundImageView.defaultDate()
    }
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

      label.textColor = UIColor(resource: .textLight100)

      return label
    }

    static func pastDate() -> Self {
      let label = self.init()

      label.textColor = UIColor(resource: .textLight30)

      return label
    }

    static func todayDate() -> Self {
      let label = self.init()

      label.textColor = UIColor(resource: .textLight100)
      label.backgroundColor = UIColor(resource: .main100)

      return label
    }

    static func dateWithEvents(in time: DayType) -> Self {
      let label = self.init()

      if time == .pastDate {
        label.textColor = UIColor(resource: .textLight30)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(resource: .textLight30).cgColor
      } else if time == .todayDate {
        label.textColor = UIColor(resource: .textLight100)
        label.backgroundColor = UIColor(resource: .main100)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(resource: .textLight100).cgColor
      } else {
        label.textColor = UIColor(resource: .textLight100)
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor(resource: .textLight100).cgColor
      }


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

      backgroundColor = UIColor(resource: .textLight100)
      textColor = UIColor(resource: .darkBackground)
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
      label.backgroundColor = UIColor(resource: .textLight30)

      return label
    }

    static func dateWithEvents(in time: DayType) -> Self {
      let label = self.init()

      if time == .pastDate {
        label.backgroundColor = UIColor(resource: .textLight30)
      }

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

    static func pastDate() -> Self {
      let imageView = self.init()

      return imageView
    }

    static func todayDate() -> Self {
      let imageView = self.init()

      return imageView
    }

    static func dateWithEvents(in time: DayType) -> Self {
      let imageView = self.init()

      if time == .pastDate {
        imageView.darkLayer.fillColor = UIColor(resource: .darkBackground).withAlphaComponent(0.9).cgColor
      } else if time == .todayDate {
        imageView.alpha = 0
      }

      return imageView
    }


    static func defaultDate() -> Self {
      let imageView = self.init()

      return imageView
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

// MARK: - Models
private indirect enum DayType: Equatable {
  case pastDate
  case todayDate
  case defaultDate
  case dateWithEvents(DayType)
}

private protocol CustomizableCalendarDateComponent: UIView {
  static func pastDate() -> Self
  static func todayDate() -> Self
  static func defaultDate() -> Self
  static func dateWithEvents(in time: DayType) -> Self
}

struct TestView_Previews: PreviewProvider {
  static var previews: some View {
    EventsCalendarViewController().makePreview()
  }
}
