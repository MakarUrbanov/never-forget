//
//  NFMonthCellViewModel.swift
//
//
//  Created by Makar Mishchenko on 06.09.2023.
//

import Foundation

public protocol INFMonthCellViewModel: AnyObject {
  var monthDataSource: INFMonthCellDataSource? { get set }
  var monthAppearanceDelegate: INFMonthCellAppearanceDelegate? { get set }
  var monthDelegate: INFMonthCellDelegate? { get set }
}

public class NFMonthCellViewModel: INFMonthCellViewModel {
  public var monthDataSource: INFMonthCellDataSource?

  public var monthAppearanceDelegate: INFMonthCellAppearanceDelegate?

  public var monthDelegate: INFMonthCellDelegate?


}
