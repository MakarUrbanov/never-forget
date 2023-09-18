//
//  INFCalendarAppearanceDelegate.swift
//
//
//  Created by Makar Mishchenko on 02.09.2023.
//

import UIKit

@MainActor
public protocol INFCalendarAppearanceDelegate: AnyObject,
  INFDayCellAppearanceDelegate,
  INFMonthHeaderAppearanceDelegate
{
  func calendarView(_ calendar: INFCalendarView, minimumLineSpacingForSectionAt: Int) -> CGFloat?
}

extension INFCalendarAppearanceDelegate {
  func calendarView(_ calendar: INFCalendarView, minimumLineSpacingForSectionAt: Int) -> CGFloat? {
    20
  }
}
