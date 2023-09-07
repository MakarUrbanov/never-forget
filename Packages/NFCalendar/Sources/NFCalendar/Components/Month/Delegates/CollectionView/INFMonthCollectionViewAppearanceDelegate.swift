//
//  INFMonthCollectionViewAppearanceDelegate.swift
//
//
//  Created by Makar Mishchenko on 03.09.2023.
//

import UIKit

public protocol INFMonthCollectionViewAppearanceDelegate: AnyObject {
  func monthCollectionView(_ month: INFMonthCollectionView, dayCell: INFDayCell, dateLabelFor date: Date) -> UILabel?

  func monthCollectionView(
    _ month: INFMonthCollectionView,
    dayCell: INFDayCell,
    badgeLabelFor date: Date,
    badgeCount: Int?
  ) -> UILabel?

  func monthCollectionView(
    _ month: INFMonthCollectionView,
    dayCell: INFDayCell,
    backgroundImageFor date: Date,
    image: UIImage?
  ) -> UIImageView?
}
