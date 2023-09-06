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

public class NFCalendarViewController: UIViewController {
  // MARK: - Private properties
  private let calendarView: INFCalendarView = NFCalendarView()

  override public func viewDidLoad() {
    super.viewDidLoad()
  }

}

// MARK: - Private methods
extension NFCalendarViewController {

  private func setupCalendar() {
    view.addSubview(calendarView)

    calendarView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

}
