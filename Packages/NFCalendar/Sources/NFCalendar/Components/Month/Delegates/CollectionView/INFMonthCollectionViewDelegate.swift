//
//  INFMonthCollectionViewDelegate.swift
//
//
//  Created by Makar Mishchenko on 04.09.2023.
//

import Foundation

public protocol INFMonthCollectionViewDelegate: AnyObject {
  func monthCollectionView(_ month: INFMonthCollectionView, didSelect date: Date)
}
