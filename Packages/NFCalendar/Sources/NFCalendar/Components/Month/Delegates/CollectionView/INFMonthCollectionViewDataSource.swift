//
//  INFMonthCollectionViewDataSource.swift
//
//
//  Created by Makar Mishchenko on 03.09.2023.
//

import UIKit

public protocol INFMonthCollectionViewDataSource: AnyObject {
  func monthCollectionView(_ month: INFMonthCollectionView, dataFor: Date) -> NFCalendarDay
}
