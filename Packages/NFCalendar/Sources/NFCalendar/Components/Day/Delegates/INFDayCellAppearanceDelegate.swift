//
//  INFDayCellAppearanceDelegate.swift
//
//
//  Created by Makar Mishchenko on 03.09.2023.
//

import UIKit

// MARK: - INFDayCellAppearanceDelegate
public protocol INFDayCellAppearanceDelegate: AnyObject {
  func dayCell(_ dayCell: INFDayCell, dateLabelFor date: Date) -> UILabel?
  func dayCell(_ dayCell: INFDayCell, badgeLabelFor date: Date, badgeCount: Int?) -> UILabel?
  func dayCell(_ dayCell: INFDayCell, backgroundImageFor date: Date, image: UIImage?) -> UIImageView?
}
