//
//  TodayDateView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.09.2023.
//

import UIKit

protocol ITodayDateView: UIStackView {}

class TodayDateView: UIStackView, ITodayDateView {

  private let dateTitle: UILabel = {
    let label = UILabel()
    label.text = TodayDateView.todayDate.toFormat(TodayDateView.todayDateFormat)
    label.textColor = UIColor(resource: .textLight100)
    label.font = UIFont.systemFont(.title3, .regular)

    return label
  }()

  private let yearTitle: UILabel = {
    let label = UILabel()
    label.text = TodayDateView.todayDate.toFormat("YYYY")
    label.textColor = UIColor(resource: .textLight30)
    label.font = UIFont.systemFont(.title3, .regular)

    return label
  }()

  // MARK: - Init
  init() {
    super.init(frame: .zero)

    axis = .horizontal
    distribution = .fill
    spacing = 8

    initialize()
  }

  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

// MARK: - Static
extension TodayDateView {

  private static let todayDate = Date.now
  private static let todayDateFormat = "EE, dd MMMM"

}

// MARK: - Private methods
extension TodayDateView {

  private func initialize() {
    addDateTitle()
    addYearTitle()
  }

  private func addDateTitle() {
    addArrangedSubview(dateTitle)
  }

  private func addYearTitle() {
    addArrangedSubview(yearTitle)
  }

}
