//
//  CalendarCell.swift
//
//
//  Created by makar on 3/26/23.
//

import Foundation
import FSCalendar
import SwiftUI

final class CalendarCell: FSCalendarCell {
  static let identifier = "CalendarCell"

  private(set) var date: Date = .now

  func configure(for date: Date, at position: FSCalendarMonthPosition) {
    self.date = date
    monthPosition = position
  }

  override func performSelecting() {
    super.performSelecting()
    shapeLayer.removeAllAnimations()
    springAnimate(isSelected: true)
  }

  override func configureAppearance() {
    super.configureAppearance()
    shapeLayer.removeAllAnimations()
    springAnimate(isSelected: false)
  }

}

// MARK: - Utils

extension CalendarCell {

  private func springAnimate(isSelected: Bool) {
    if isSelected {
      transform = CGAffineTransform(scaleX: 0.8, y: 0.8)

      UIView.animate(
        withDuration: 0.4,
        delay: 0,
        usingSpringWithDamping: 0.5,
        initialSpringVelocity: 3,
        options: .curveEaseInOut
      ) {
        self.transform = CGAffineTransform(scaleX: 1, y: 1)
      }
    } else {
      transform = CGAffineTransform(scaleX: 1, y: 1)
    }

  }

}
