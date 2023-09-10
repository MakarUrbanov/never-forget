//
//  NFDayType.swift
//
//
//  Created by Makar Mishchenko on 10.09.2023.
//

import Foundation

public indirect enum NFDayType: Equatable {
  case pastDate
  case todayDate
  case defaultDate
  case dateWithEvents(NFDayType)
}
