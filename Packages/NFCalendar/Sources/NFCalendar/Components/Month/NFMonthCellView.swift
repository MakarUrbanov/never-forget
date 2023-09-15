//
//  NFMonthCellView.swift
//
//
//  Created by Makar Mishchenko on 14.08.2023.
//

import SnapKit
import SwiftDate
import UIKit

// MARK: - INFMonthCell
public protocol INFMonthCell: UICollectionViewCell {
  static var headerHeight: CGFloat { get }

  var separatorColor: UIColor { get set }
  var separator: UIView { get }

  var monthDataSource: INFMonthCellDataSource? { get set }
  var datesAppearanceDelegate: INFDayCellAppearanceDelegate? { get set }
  var monthHeaderAppearanceDelegate: INFMonthHeaderAppearanceDelegate? { get set }
  var monthDelegate: INFMonthCellDelegate? { get set }

  func renderMonthData(_ date: NFMonthData)
}

// MARK: - NFMonthCellView
public class NFMonthCellView: UICollectionViewCell, INFMonthCell {

  // MARK: - Public properties
  public var separatorColor: UIColor = .clear
  public var separator = UIView()

  // MARK: - Delegates
  public weak var monthDataSource: INFMonthCellDataSource?
  public weak var datesAppearanceDelegate: INFDayCellAppearanceDelegate?
  public weak var monthHeaderAppearanceDelegate: INFMonthHeaderAppearanceDelegate?
  public weak var monthDelegate: INFMonthCellDelegate?

  // MARK: - Private properties
  private var monthCollectionView: INFMonthCollectionView =
    NFMonthCollectionView(viewModel: NFMonthCollectionViewModel())
  private var monthHeaderView: INFMonthHeader = NFMonthHeaderView()

  // MARK: - Init
  override public init(frame: CGRect) {
    super.init(frame: frame)

    initialize()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public properties
  public func renderMonthData(_ monthData: NFMonthData) {
    monthHeaderView.configure(with: monthData.firstMonthDate)
    monthCollectionView.setupMonthData(monthData)
    separator.backgroundColor = separatorColor
  }

}

// MARK: - INFMonthCollectionViewDataSource
extension NFMonthCellView: INFMonthCollectionViewDataSource {

  public func monthCollectionView(_ month: INFMonthCollectionView, dataFor date: Date) -> NFCalendarDay {
    return monthDataSource?.monthCellView(self, dataFor: date) ?? .init(
      date: date,
      backgroundImage: nil,
      badgeCount: nil
    )
  }
}

// MARK: - Initialize UI
extension NFMonthCellView {

  private func initialize() {
    initializeMonthHeaderView()
    initializeMonthView()
    initializeSeparator()
  }

  private func initializeMonthHeaderView() {
    monthHeaderView.appearanceDelegate = self

    addSubview(monthHeaderView)

    monthHeaderView.snp.makeConstraints { make in
      make.height.equalTo(NFMonthCellView.headerHeight)
      make.leading.top.trailing.equalToSuperview()
    }
  }

  private func initializeMonthView() {
    monthCollectionView.datesAppearanceDelegate = self
    monthCollectionView.monthDataSource = self
    monthCollectionView.monthDelegate = self

    addSubview(monthCollectionView)

    monthCollectionView.snp.makeConstraints { make in
      make.leading.bottom.trailing.equalToSuperview()
      make.top.equalTo(monthHeaderView.snp.bottom)
    }
  }

  private func initializeSeparator() {
    separator.backgroundColor = separatorColor
    addSubview(separator)
    separator.snp.makeConstraints { make in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(1)
    }
  }

}

// MARK: - Static
extension NFMonthCellView {

  public static let headerHeight: CGFloat = 80
  private static let calendar = DateInRegion().calendar

  private static func getDaysCountInMonth(of date: Date) -> Int {
    date.in(region: .current).monthDays
  }

  private static func getFirstDateOfMonth(of date: Date) -> Date {
    date.dateAtStartOf(.month).date
  }

}

// MARK: - INFMonthHeaderAppearanceDelegate
extension NFMonthCellView: INFMonthHeaderAppearanceDelegate {

  public func monthHeader(
    _ header: INFMonthHeader,
    weekdaysView: INFMonthWeekdays,
    labelForWeekday weekday: Int
  ) -> UILabel? {
    monthHeaderAppearanceDelegate?.monthHeader(header, weekdaysView: weekdaysView, labelForWeekday: weekday)
  }

  public func monthHeader(_ header: INFMonthHeader, labelForMonth monthDate: Date) -> UILabel? {
    monthHeaderAppearanceDelegate?.monthHeader(header, labelForMonth: monthDate)
  }

}

// MARK: - INFDayCellAppearanceDelegate
extension NFMonthCellView: INFDayCellAppearanceDelegate {

  public func dayCellComponents(_ dayCell: INFDayCell) -> NFDayComponents? {
    datesAppearanceDelegate?.dayCellComponents(dayCell)
  }

  public func dayCell(_ dayCell: INFDayCell, setupDateLabel label: INFDayLabel, ofDate date: Date) {
    datesAppearanceDelegate?.dayCell(dayCell, setupDateLabel: label, ofDate: date)
  }

  public func dayCell(
    _ dayCell: INFDayCell,
    setupBadgeLabel label: INFDayBadgeLabel,
    ofDate date: Date,
    badgeCount: Int?
  ) {
    datesAppearanceDelegate?.dayCell(dayCell, setupBadgeLabel: label, ofDate: date, badgeCount: badgeCount)
  }

  public func dayCell(
    _ dayCell: INFDayCell,
    setupBackgroundImage imageView: INFDayBackgroundImageView,
    ofDate date: Date,
    image: UIImage?
  ) {
    datesAppearanceDelegate?.dayCell(dayCell, setupBackgroundImage: imageView, ofDate: date, image: image)
  }

}

// MARK: - INFMonthCollectionViewDelegate
extension NFMonthCellView: INFMonthCollectionViewDelegate {

  public func monthCollectionView(_ month: INFMonthCollectionView, didSelect date: Date) {
    monthDelegate?.monthCollectionView(self, didSelect: date)
  }

}
