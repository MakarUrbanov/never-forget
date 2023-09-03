//
//  INFMonthCellAppearanceDelegate.swift
//
//
//  Created by Makar Mishchenko on 03.09.2023.
//

import UIKit

public protocol INFMonthCellAppearanceDelegate: AnyObject {
  // MARK: - Header
  func monthCell(_ month: INFMonthCell, header: INFMonthHeader, labelForWeekday weekday: String) -> UILabel?
  func monthCell(_ month: INFMonthCell, header: INFMonthHeader, labelForMonth monthDate: Date) -> UILabel?
  // MARK: - Day
  func monthCell(_ month: INFMonthCell, dayCell: INFDayCell, dateLabelFor date: Date) -> UILabel?
  func monthCell(_ month: INFMonthCell, dayCell: INFDayCell, badgeLabelFor date: Date, badgeCount: Int?) -> UILabel?
  func monthCell(_ month: INFMonthCell, dayCell: INFDayCell, backgroundImageFor date: Date, image: UIImage?)
    -> UIImageView?
}
