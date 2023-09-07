//
//  NFCalendarViewDataSource.swift
//
//  Created by Makar Mishchenko on 13.08.2023.
//

import UIKit

public protocol INFCalendarDataSource: AnyObject {
  func calendarView(_ calendar: NFCalendarView, dataFor date: Date) -> NFCalendarDay?
}

// MARK: - Making the optional methods
public extension INFCalendarDataSource {
  func calendarView(_ calendar: NFCalendarView, dataFor date: Date) -> NFCalendarDay? {
    nil
  }
}
