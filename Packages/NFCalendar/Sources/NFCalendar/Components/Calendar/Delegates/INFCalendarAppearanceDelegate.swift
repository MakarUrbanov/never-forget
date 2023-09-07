//
//  INFCalendarAppearanceDelegate.swift
//
//
//  Created by Makar Mishchenko on 02.09.2023.
//

import UIKit

public protocol INFCalendarAppearanceDelegate: AnyObject {
  // MARK: - Calendar
  func calendarView(_ calendar: INFCalendarView, minimumLineSpacingForSectionAt: Int) -> CGFloat?
  // MARK: - Header
  func calendarView(_ calendar: INFCalendarView, header: INFMonthHeader, labelForWeekday weekday: Int) -> UILabel?
  func calendarView(_ calendar: INFCalendarView, header: INFMonthHeader, labelForMonth monthDate: Date) -> UILabel?
  // MARK: - Day
  func calendarView(_ calendar: INFCalendarView, dayCell: INFDayCell, dateLabelFor date: Date) -> UILabel?
  func calendarView(_ calendar: INFCalendarView, dayCell: INFDayCell, badgeLabelFor date: Date, badgeCount: Int?)
    -> UILabel?
  func calendarView(_ calendar: INFCalendarView, dayCell: INFDayCell, backgroundImageFor date: Date, image: UIImage?)
    -> UIImageView?
}

// MARK: - Making methods optional
public extension INFCalendarAppearanceDelegate {
  // MARK: - Calendar
  func calendarView(_ calendar: INFCalendarView, minimumLineSpacingForSectionAt: Int) -> CGFloat? { nil }
  // MARK: - Header
  func calendarView(
    _ calendar: INFCalendarView,
    header: INFMonthHeader,
    labelForWeekday weekday: Int
  ) -> UILabel? { nil }
  func calendarView(
    _ calendar: INFCalendarView,
    header: INFMonthHeader,
    labelForMonth monthDate: Date
  ) -> UILabel? { nil }
  // MARK: - Day
  func calendarView(_ calendar: INFCalendarView, dayCell: INFDayCell, dateLabelFor date: Date) -> UILabel? { nil }
  func calendarView(
    _ calendar: INFCalendarView,
    dayCell: INFDayCell,
    badgeLabelFor date: Date,
    badgeCount: Int?
  ) -> UILabel? { nil }
  func calendarView(
    _ calendar: INFCalendarView,
    dayCell: INFDayCell,
    backgroundImageFor date: Date,
    image: UIImage?
  ) -> UIImageView? { nil }
}
