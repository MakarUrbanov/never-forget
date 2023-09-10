//
//  INFDayCellAppearanceDelegate.swift
//
//
//  Created by Makar Mishchenko on 03.09.2023.
//

import UIKit

public protocol INFDayCellAppearanceDelegate: AnyObject {
  func dayCellComponents(_ dayCell: INFDayCell) -> NFDayComponents?

  func dayCell(_ dayCell: INFDayCell, setupDateLabel label: INFDayLabel, ofDate date: Date)
  func dayCell(_ dayCell: INFDayCell, setupBadgeLabel label: INFDayBadgeLabel, ofDate date: Date, badgeCount: Int?)
  func dayCell(
    _ dayCell: INFDayCell,
    setupBackgroundImage imageView: INFDayBackgroundImageView,
    ofDate date: Date,
    image: UIImage?
  )
}
