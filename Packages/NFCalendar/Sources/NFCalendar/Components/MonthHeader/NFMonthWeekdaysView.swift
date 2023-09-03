//
//  NFMonthWeekdaysView.swift
//
//
//  Created by Makar Mishchenko on 02.09.2023.
//

import UIKit

public protocol INFMonthWeekdays: UIStackView {
  var appearanceDelegate: INFMonthWeekdaysAppearanceDelegate? { get set }

  func renderWeekdays()
}

public class NFMonthWeekdaysView: UIStackView, INFMonthWeekdays {

  // MARK: - Public properties
  public weak var appearanceDelegate: INFMonthWeekdaysAppearanceDelegate?

  // MARK: - Init
  override public init(frame: CGRect) {
    super.init(frame: frame)

    axis = .horizontal
    distribution = .fillEqually
    spacing = NFMonthCollectionView.dateCellsPadding
  }

  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public methods
  public func renderWeekdays() {
    removeWeekdays()

    let weekdaysView = generateWeekdays()

    setupWeekdays(weekdaysView)
  }

}

// MARK: - Private methods
private extension NFMonthWeekdaysView {

  private func setupWeekdays(_ weekdaysView: [UILabel]) {
    let size = bounds.width / 7

    for weekdayView in weekdaysView {
      addArrangedSubview(weekdayView)
    }
  }

  private func generateWeekdays() -> [UILabel] {
    let weekdays = NFMonthWeekdaysView.localizedWeekdays()
    let weekdaysView = weekdays.map { weekday in
      let labelFromDelegate = appearanceDelegate?.weekdaysView(self, labelForWeekday: weekday.weekdayNumber)
      let label = labelFromDelegate ?? NFMonthWeekdaysView.defaultLabel()
      label.text = weekday.name

      return label
    }

    return weekdaysView
  }

  private func removeWeekdays() {
    arrangedSubviews.forEach { $0.removeFromSuperview() }
  }

}

// MARK: - Static
extension NFMonthWeekdaysView {

  // MARK: - Static methods
  private static func defaultLabel() -> UILabel {
    let label = UILabel()
    label.font = .systemFont(ofSize: 14, weight: .bold)
    label.textAlignment = .center
    return label
  }

  private static func localizedWeekdays() -> [Weekday] {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current

    guard let shortWeekdaySymbols = dateFormatter.shortWeekdaySymbols else {
      return []
    }

    let firstWeekdayIndex = Calendar.current.firstWeekday - 1

    let reorderedWeekdays = Array(shortWeekdaySymbols[firstWeekdayIndex...] + shortWeekdaySymbols[..<firstWeekdayIndex])

    var weekdays: [Weekday] = []

    for (index, symbol) in reorderedWeekdays.enumerated() {
      let weekdayNumber = (firstWeekdayIndex + index) % 7 + 1
      weekdays.append(Weekday(name: String(symbol.prefix(2)), weekdayNumber: weekdayNumber))
    }

    return weekdays
  }

}

// MARK: - Models
private extension NFMonthWeekdaysView {

  private struct Weekday {
    var name: String
    var weekdayNumber: Int
  }

}
