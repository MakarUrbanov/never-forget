//
//  EventDatePicker.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 08.10.2023.
//

import SnapKit
import SwiftDate
import UIKit

protocol IEventDatePickerDelegate: AnyObject {
  func didChangeDate(datePicker: IEventDatePicker, date: Date)
}

protocol IEventDatePicker: UIViewController {
  var delegate: IEventDatePickerDelegate? { get set }
  var interval: DateInterval { get }

  func setDate(date: Date)
}

class EventDatePicker: UIViewController, IEventDatePicker {

  weak var delegate: IEventDatePickerDelegate?
  var interval: DateInterval

  private lazy var selectionBehavior = UICalendarSelectionSingleDate(delegate: self)
  private lazy var calendarView = UICalendarView()

  init(interval: DateInterval) {
    self.interval = interval

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    initializeUI()
  }

  func setDate(date: Date) {
    selectionBehavior.setSelected(date.dateComponents, animated: true)
  }

}

private extension EventDatePicker {

  private func initializeUI() {
    setupCalendarView()
  }

  private func setupCalendarView() {
    calendarView.availableDateRange = interval
    calendarView.selectionBehavior = selectionBehavior

    view.addSubview(calendarView)

    calendarView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}

extension EventDatePicker: UICalendarSelectionSingleDateDelegate {

  func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
    if let date = dateComponents?.date {
      delegate?.didChangeDate(datePicker: self, date: date)
    }
  }

}
