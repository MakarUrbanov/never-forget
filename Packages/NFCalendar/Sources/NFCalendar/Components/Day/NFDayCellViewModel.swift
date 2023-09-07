//
//  NFDayCellViewModel.swift
//
//
//  Created by Makar Mishchenko on 06.09.2023.
//

import NFCore
import SwiftDate
import UIKit

public protocol INFDayCellViewModel: AnyObject {
  var date: Observable<Date>? { get set }

  var badgeCount: Observable<Int?>? { get set }
  var backgroundImage: Observable<UIImage?>? { get set }
}

public class NFDayCellViewModel: INFDayCellViewModel {

  // MARK: - Public properties
  public var backgroundImage: Observable<UIImage?>?
  public var date: Observable<Date>?
  public var badgeCount: Observable<Int?>?
}
