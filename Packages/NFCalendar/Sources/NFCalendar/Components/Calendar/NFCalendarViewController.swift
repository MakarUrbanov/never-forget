//
//  NFCalendarViewController.swift
//
//
//  Created by Makar Mishchenko on 06.09.2023.
//

import SnapKit
import UIKit

public protocol INFCalendarViewController: UIViewController {
  var calendarView: INFCalendarView { get }
}

open class NFCalendarViewController: UIViewController, INFCalendarViewController {

  public let calendarView: INFCalendarView = NFCalendarView(viewModel: NFCalendarViewModel())

  override open func viewDidLoad() {
    super.viewDidLoad()

    setupCalendar()
  }

}

// MARK: - Private methods
extension NFCalendarViewController {

  private func setupCalendar() {
    view.addSubview(calendarView)

    calendarView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    calendarView.backgroundColor = .clear
    calendarView.renderCalendar()
  }

}
