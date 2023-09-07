//
//  NFCalendarDay.swift
//
//
//  Created by Makar Mishchenko on 14.08.2023.
//

import UIKit

public struct NFCalendarDay {
  public var date: Date
  public var backgroundImage: UIImage?
  public var badgeCount: Int?

  public init(
    date: Date,
    backgroundImage: UIImage? = nil,
    badgeCount: Int? = nil
  ) {
    self.date = date
    self.backgroundImage = backgroundImage
    self.badgeCount = badgeCount
  }
}
