//
//  NFMonthHeaderView.swift
//
//
//  Created by Makar Mishchenko on 19.08.2023.
//

import SnapKit
import UIKit

// MARK: - INFMonthHeader
public protocol INFMonthHeader: UIView {
  var titleLabel: UILabel { get }
  var weekdaysView: INFMonthWeekdays { get }

  func configure(with date: Date)

  var appearanceDelegate: INFMonthHeaderAppearanceDelegate? { get set }
}

// MARK: - NFMonthHeaderView
public class NFMonthHeaderView: UIView, INFMonthHeader {

  // MARK: - Public properties
  public private(set) var titleLabel: UILabel = BaseTitleLabel()
  public private(set) var weekdaysView: INFMonthWeekdays = NFMonthWeekdaysView()

  public weak var appearanceDelegate: INFMonthHeaderAppearanceDelegate?

  // MARK: - Public methods
  public func configure(with date: Date) {
    initialize()

    if let labelFromDelegate = appearanceDelegate?.monthHeader(self, labelForMonth: date) {
      titleLabel = labelFromDelegate
      setupTitleLabel()
    }


    let title = NFMonthHeaderView.titleDateFormatter.string(from: date)
    titleLabel.text = title
  }
}

// MARK: - Private methods
private extension NFMonthHeaderView {

  private func initialize() {
    setupTitleLabel()
    setupWeekdaysView()
  }

  private func setupTitleLabel() {
    addSubview(titleLabel)

    titleLabel.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalToSuperview().dividedBy(2)
    }
  }

  private func setupWeekdaysView() {
    addSubview(weekdaysView)

    weekdaysView.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }

    weekdaysView.appearanceDelegate = self

    weekdaysView.renderWeekdays()
  }

}

// MARK: - Static
extension NFMonthHeaderView {

  // MARK: - Static properties
  private static let titleDateFormatter = DateFormatter(dateFormat: "MMMM YYYY")

}

// MARK: - NFMonthWeekdaysAppearanceDelegate
extension NFMonthHeaderView: INFMonthWeekdaysAppearanceDelegate {

  public func weekdaysView(_ weekdaysView: INFMonthWeekdays, labelForWeekday weekday: String) -> UILabel? {
    appearanceDelegate?.monthHeader(self, weekdaysView: weekdaysView, labelForWeekday: weekday)
  }

}

// MARK: - UI Components
public extension NFMonthHeaderView {

  // MARK: - BaseTitleLabel
  final class BaseTitleLabel: UILabel {
    override public init(frame: CGRect) {
      super.init(frame: frame)

      initialize()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func initialize() {
      textAlignment = .center
      font = .systemFont(ofSize: 16)
    }
  }

}
