//
//  INFCustomizableDay.swift
//
//
//  Created by Makar Mishchenko on 10.09.2023.
//

import UIKit

public protocol INFCustomizableDay: AnyObject {
  var dayType: NFDayType { get }

  func setDayType(_ dayType: NFDayType)
}
