//
//  File.swift
//
//
//  Created by makar on 3/26/23.
//

import Foundation
import FSCalendar
import SwiftUI

public final class NeverForgetDatePickerView: FSCalendar {

  private var colorScheme: ColorScheme

  weak var myDelegate: NeverForgetDatePickerViewMyDelegate?

  private var calendarHeight: NSLayoutConstraint?

  init(colorScheme: ColorScheme) {
    self.colorScheme = colorScheme

    super.init(frame: .zero)

    allowsMultipleSelection = false
    delegate = self
    dataSource = self
    scope = .week

    register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.identifier)
    headerHeight = 20
    weekdayHeight = 20
    calendarHeight = heightAnchor.constraint(equalToConstant: 100)
    calendarHeight?.isActive = true
  }

  @available(*, unavailable) required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func updateColorScheme(_ colorScheme: ColorScheme) {
    self.colorScheme = colorScheme
    reloadData()
  }

}

// MARK: FSCalendarDataSource

extension NeverForgetDatePickerView: FSCalendarDataSource {

  public func calendar(
    _ calendar: FSCalendar,
    cellFor date: Date,
    at position: FSCalendarMonthPosition
  ) -> FSCalendarCell {
    let cell = calendar.dequeueReusableCell(
      withIdentifier: CalendarCell.identifier,
      for: date,
      at: position
    ) as! CalendarCell // swiftlint:disable:this force_cast
    return cell
  }

  public func calendar(
    _: FSCalendar,
    willDisplay _: FSCalendarCell,
    for date: Date,
    at position: FSCalendarMonthPosition
  ) {
    let calendarCell = CalendarCell()
    calendarCell.configure(for: date, at: position)
  }

  public func minimumDate(for _: FSCalendar) -> Date {
    Date.now
  }

  public func calendar(_: FSCalendar, titleFor date: Date) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "d"
    return dateFormatter.string(from: date)
  }

  public func calendar(_: FSCalendar, appearance _: FSCalendarAppearance, eventDefaultColorsFor _: Date) -> [UIColor]? {
    colorScheme == .dark ? [.white] : [.black]
  }

  public func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    let isEventExists = myDelegate?.customCalendar?(calendar, eventExists: date) ?? false

    return isEventExists ? 1 : 0
  }

  public func calendar(
    _: FSCalendar,
    appearance _: FSCalendarAppearance,
    eventSelectionColorsFor _: Date
  ) -> [UIColor]? {
    colorScheme == .dark ? [.white] : [.black]
  }

  public func calendar(_: FSCalendar, appearance _: FSCalendarAppearance, eventOffsetFor _: Date) -> CGPoint {
    CGPoint(x: 0, y: 4)
  }

}

// MARK: FSCalendarDelegate


extension NeverForgetDatePickerView: FSCalendarDelegate {

  public func calendar(_: FSCalendar, boundingRectWillChange bounds: CGRect, animated _: Bool) {
    calendarHeight?.constant = bounds.height
    layoutIfNeeded()
  }

  public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    myDelegate?.customCalendar?(calendar, didSelect: date, at: monthPosition)
  }

}

// MARK: FSCalendarDelegateAppearance

extension NeverForgetDatePickerView: FSCalendarDelegateAppearance {

  public func calendar(_: FSCalendar, appearance _: FSCalendarAppearance, fillSelectionColorFor _: Date) -> UIColor? {
    colorScheme == .dark ? .white : .black
  }

  public func calendar(_: FSCalendar, appearance _: FSCalendarAppearance, titleDefaultColorFor _: Date) -> UIColor? {
    colorScheme == .dark ? .white : .black
  }

  public func calendar(_: FSCalendar, appearance _: FSCalendarAppearance, titleSelectionColorFor _: Date) -> UIColor? {
    colorScheme == .dark ? .black : .white
  }

  public func calendar(_: FSCalendar, appearance _: FSCalendarAppearance, fillDefaultColorFor _: Date) -> UIColor? {
    .clear
  }

}
