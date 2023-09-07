//
//  INFMonthCellDataSource.swift
//
//
//  Created by Makar Mishchenko on 03.09.2023.
//

import UIKit

public protocol INFMonthCellDataSource: AnyObject {
  func monthCellView(_ month: NFMonthCellView, dataFor date: Date) -> NFCalendarDay
}
