//
//  NeverForgetDatePickerView.swift
//
//
//  Created by makar on 3/26/23.
//

import Foundation
import FSCalendar
import SwiftUI

public final class NeverForgetDatePickerView: FSCalendar {

  private(set) var colorScheme: ColorScheme

  weak var myDelegate: NeverForgetDatePickerViewMyDelegate?

  init(colorScheme: ColorScheme) {
    self.colorScheme = colorScheme

    super.init(frame: .zero)

    allowsMultipleSelection = false
    delegate = self
    dataSource = self
    scope = .week

    register(CalendarCell.self, forCellReuseIdentifier: CalendarCell.identifier)
    headerHeight = 30
    weekdayHeight = 20

    setAppearance()
  }

  @available(*, unavailable) required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

extension NeverForgetDatePickerView {

  func updateColorScheme(_ colorScheme: ColorScheme) {
    if self.colorScheme != colorScheme {
      self.colorScheme = colorScheme
      setAppearance()
      reloadData()
    }
  }

  private func setAppearance() {
    appearance.headerDateFormat = "MMM yyy"
    appearance.headerMinimumDissolvedAlpha = 0.1
    appearance.headerTitleColor = colorScheme == .dark ? .white : .black
    appearance.weekdayTextColor = colorScheme == .dark ? .white : .black
  }

}
