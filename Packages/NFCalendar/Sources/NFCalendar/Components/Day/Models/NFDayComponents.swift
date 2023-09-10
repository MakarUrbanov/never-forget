//
//  NFDayComponents.swift
//
//
//  Created by Makar Mishchenko on 10.09.2023.
//

import UIKit

public struct NFDayComponents {
  public let dateLabel: INFDayLabel.Type
  public let dateBadgeLabel: INFDayBadgeLabel.Type
  public let dateBackgroundImage: INFDayBackgroundImageView.Type

  public init(
    dateLabel: INFDayLabel.Type,
    dateBadgeLabel: INFDayBadgeLabel.Type,
    dateBackgroundImage: INFDayBackgroundImageView.Type
  ) {
    self.dateLabel = dateLabel
    self.dateBadgeLabel = dateBadgeLabel
    self.dateBackgroundImage = dateBackgroundImage
  }
}
