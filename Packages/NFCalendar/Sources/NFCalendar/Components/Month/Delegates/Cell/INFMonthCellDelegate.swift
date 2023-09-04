//
//  INFMonthCellDelegate.swift
//
//
//  Created by Makar Mishchenko on 04.09.2023.
//

import Foundation

public protocol INFMonthCellDelegate: AnyObject {
  func monthCollectionView(_ month: INFMonthCell, didSelect date: Date)
}
