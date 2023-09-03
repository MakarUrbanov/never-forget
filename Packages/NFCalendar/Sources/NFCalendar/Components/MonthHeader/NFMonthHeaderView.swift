//
//  NFMonthHeaderView.swift
//
//
//  Created by Makar Mishchenko on 19.08.2023.
//

import SnapKit
import UIKit

// MARK: - INFMonthHeader
public protocol INFMonthHeader: UIStackView {
  var titleLabel: UILabel { get }
  var weekdaysView: INFMonthWeekdays { get }

  func configure(with date: Date)

  var appearanceDelegate: INFMonthHeaderAppearanceDelegate? { get set }
}

// MARK: - NFMonthHeaderView
public class NFMonthHeaderView: UIStackView, INFMonthHeader {

  // MARK: - Public properties
  public private(set) var titleLabel: UILabel = BaseTitleLabel()
  public private(set) var weekdaysView: INFMonthWeekdays = NFMonthWeekdaysView()

  public weak var appearanceDelegate: INFMonthHeaderAppearanceDelegate?

  override public init(frame: CGRect) {
    super.init(frame: frame)

    axis = .vertical
    distribution = .fillEqually
    spacing = 0
  }

  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public methods
  public func configure(with date: Date) {
    setupTitleLabel(with: date)

    weekdaysView.removeFromSuperview()
    weekdaysView = NFMonthWeekdaysView()
    setupWeekdaysView()
    weekdaysView.renderWeekdays()

    setHeaderTitle(from: date)
  }
}

// MARK: - Private methods
private extension NFMonthHeaderView {

  private func setupTitleLabel(with date: Date) {
    if let labelFromDelegate = appearanceDelegate?.monthHeader(self, labelForMonth: date) {
      titleLabel.removeFromSuperview()
      titleLabel = labelFromDelegate
    }

    addArrangedSubview(titleLabel)

    titleLabel.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalToSuperview().dividedBy(2)
    }
  }

  private func setupWeekdaysView() {
    weekdaysView.removeFromSuperview()
    weekdaysView = NFMonthWeekdaysView()
    weekdaysView.appearanceDelegate = self

    addArrangedSubview(weekdaysView)

    weekdaysView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalToSuperview().dividedBy(2)
    }

    weekdaysView.renderWeekdays()
  }

  private func setHeaderTitle(from date: Date) {
    titleLabel.text = NFMonthHeaderView.titleDateFormatter.string(from: date)
  }

}

// MARK: - Static
extension NFMonthHeaderView {

  // MARK: - Static properties
  private static let titleDateFormatter = DateFormatter(dateFormat: "MMMM YYYY")

}

// MARK: - NFMonthWeekdaysAppearanceDelegate
extension NFMonthHeaderView: INFMonthWeekdaysAppearanceDelegate {

  public func weekdaysView(_ weekdaysView: INFMonthWeekdays, labelForWeekday weekday: Int) -> UILabel? {
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
