//
//  DatePickerSingleSelection.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 08.10.2023.
//

import SnapKit
import SwiftDate
import UIKit

protocol IDatePickerSingleSelectionDelegate: AnyObject {
  func didChangeDate(datePicker: IDatePickerSingleSelection, date: Date)
}

protocol IDatePickerSingleSelection: UIView {
  var delegate: IDatePickerSingleSelectionDelegate? { get set }
  var availableDateRange: DateInterval { get }

  func setDate(date: Date)
}

class DatePickerSingleSelection: UIView, IDatePickerSingleSelection {

  weak var delegate: IDatePickerSingleSelectionDelegate?
  var availableDateRange: DateInterval

  private lazy var selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
  private lazy var calendarView = UICalendarView()

  init(availableDateRange: DateInterval) {
    self.availableDateRange = availableDateRange

    super.init(frame: .zero)

    initializeUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setDate(date: Date) {
    selectionBehavior.setSelected(date.dateComponents, animated: true)
  }

}

private extension DatePickerSingleSelection {

  private func initializeUI() {
    setupCalendarView()
  }

  private func setupCalendarView() {
    calendarView.availableDateRange = availableDateRange
    calendarView.selectionBehavior = selectionBehavior

    addSubview(calendarView)

    calendarView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}

extension DatePickerSingleSelection: UICalendarSelectionSingleDateDelegate {

  func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
    if let date = dateComponents?.date {
      delegate?.didChangeDate(datePicker: self, date: date)
    }
  }

}
