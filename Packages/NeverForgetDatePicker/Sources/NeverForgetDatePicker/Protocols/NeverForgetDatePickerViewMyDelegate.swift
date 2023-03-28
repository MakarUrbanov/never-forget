//
//  File.swift
//
//
//  Created by makar on 3/26/23.
//

import FSCalendar

@objc protocol NeverForgetDatePickerViewMyDelegate {

  @objc optional func customCalendar(
    _ calendar: FSCalendar,
    didSelect date: Date,
    at monthPosition: FSCalendarMonthPosition
  )

  @objc optional func customCalendar(_ calendar: FSCalendar, eventExists date: Date) -> Bool
}
