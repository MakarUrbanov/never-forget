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
  public var appearanceDelegate: INFMonthWeekdaysAppearanceDelegate?

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
    let weekdays = NFMonthWeekdaysView.localizedWeekdays()
    let weekdaysView = weekdays.map { weekday in
      let labelFromDelegate = appearanceDelegate?.weekdaysView(self, labelForWeekday: weekday)
      let label = labelFromDelegate ?? NFMonthWeekdaysView.defaultLabel()
      label.text = weekday

      return label
    }

    let size = bounds.width / 7

    for weekdayView in weekdaysView {
      addArrangedSubview(weekdayView)

      weekdayView.snp.makeConstraints { make in
        make.width.height.equalTo(size)
      }
    }
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

  private static func localizedWeekdays() -> [String] {
    //    let calendar = Calendar.current
    //    let firstWeekday = calendar.firstWeekday

    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale.current

    let weekdays = dateFormatter.shortWeekdaySymbols?.map { String($0.prefix(2)) } ?? []
    //    let weekdaysSorted = Array(weekdays[(firstWeekday - 1)..<weekdays.count] + weekdays[0..<(firstWeekday - 1)])

    return weekdays
  }

}
