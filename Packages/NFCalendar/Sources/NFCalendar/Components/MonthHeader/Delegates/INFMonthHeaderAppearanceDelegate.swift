//
//  INFMonthHeaderAppearanceDelegate.swift
//
//
//  Created by Makar Mishchenko on 03.09.2023.
//

import UIKit

public protocol INFMonthHeaderAppearanceDelegate: AnyObject {
  func monthHeader(_ header: INFMonthHeader, weekdaysView: INFMonthWeekdays, labelForWeekday weekday: Int)
    -> UILabel?
  func monthHeader(_ header: INFMonthHeader, labelForMonth monthDate: Date) -> UILabel?
}
