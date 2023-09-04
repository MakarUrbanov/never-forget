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

  var monthDataSource: INFMonthCellDataSource? { get set }
  var monthAppearanceDelegate: INFMonthCellAppearanceDelegate? { get set }

  func renderMonth(_ date: Date)
}

// MARK: - NFMonthCellView
public class NFMonthCellView: UICollectionViewCell, INFMonthCell {

  // MARK: - Delegates
  public weak var monthDataSource: INFMonthCellDataSource?
  public weak var monthAppearanceDelegate: INFMonthCellAppearanceDelegate?

  // MARK: - Private properties
  private var monthCollectionView: INFMonthCollectionView = NFMonthCollectionView(
    frame: .zero,
    collectionViewLayout: UICollectionViewFlowLayout()
  )
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
  public func renderMonth(_ date: Date) {
    let days = NFMonthCellView.getMonthDays(of: date)

    monthHeaderView.configure(with: date)
    monthCollectionView.setupMonthDates(days)
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

// MARK: - Private
extension NFMonthCellView {

  private func initialize() {
    setupMonthHeaderView()
    setupMonthView()
  }

  private func setupMonthHeaderView() {
    monthHeaderView.appearanceDelegate = self

    addSubview(monthHeaderView)

    monthHeaderView.snp.makeConstraints { make in
      make.height.equalTo(NFMonthCellView.headerHeight)
      make.leading.top.trailing.equalToSuperview()
    }
  }

  private func setupMonthView() {
    monthCollectionView.appearanceDelegate = self
    monthCollectionView.monthDataSource = self

    addSubview(monthCollectionView)

    monthCollectionView.snp.makeConstraints { make in
      make.leading.bottom.trailing.equalToSuperview()
      make.top.equalTo(monthHeaderView.snp.bottom)
    }
  }

}

// MARK: - Static
extension NFMonthCellView {

  // MARK: - Static properties
  public static let headerHeight: CGFloat = 80
  private static let calendar = DateInRegion().calendar

  private static func getDaysInMonth(of date: Date) -> Int {
    guard let daysInMonthRange = calendar.range(of: .day, in: .month, for: date) else {
      fatalError("Something went wrong")
    }

    return daysInMonthRange.upperBound - 1
  }

  private static func getFirstDateOfMonth(of date: Date) -> Date {
    let components = calendar.dateComponents([.year, .month], from: date)
    guard let firstDateOfMonth = calendar.date(from: components) else {
      fatalError("Something went wrong")
    }

    return firstDateOfMonth
  }

  private static func getMonthDays(of date: Date) -> [Date] {
    let daysInMonth = NFMonthCellView.getDaysInMonth(of: date)
    let firstDayOfMonth = NFMonthCellView.getFirstDateOfMonth(of: date)
    var daysList: [Date] = []

    for day in 0..<daysInMonth {
      guard let newDate = calendar.date(bySetting: .day, value: 1 + day, of: firstDayOfMonth) else {
        fatalError("Something went wrong")
      }
      daysList.append(newDate)
    }

    return daysList
  }
}

// MARK: - INFMonthHeaderAppearanceDelegate
extension NFMonthCellView: INFMonthHeaderAppearanceDelegate {

  public func monthHeader(
    _ header: INFMonthHeader,
    weekdaysView: INFMonthWeekdays,
    labelForWeekday weekday: Int
  ) -> UILabel? {
    monthAppearanceDelegate?.monthCell(self, header: header, labelForWeekday: weekday)
  }

  public func monthHeader(_ header: INFMonthHeader, labelForMonth monthDate: Date) -> UILabel? {
    monthAppearanceDelegate?.monthCell(self, header: header, labelForMonth: monthDate)
  }

}

// MARK: - INFMonthCollectionViewAppearanceDelegate
extension NFMonthCellView: INFMonthCollectionViewAppearanceDelegate {

  public func monthCollectionView(
    _ month: INFMonthCollectionView,
    dayCell: INFDayCell,
    dateLabelFor date: Date
  ) -> UILabel? {
    monthAppearanceDelegate?.monthCell(self, dayCell: dayCell, dateLabelFor: date)
  }

  public func monthCollectionView(
    _ month: INFMonthCollectionView,
    dayCell: INFDayCell,
    badgeLabelFor date: Date,
    badgeCount: Int?
  ) -> UILabel? {
    monthAppearanceDelegate?.monthCell(self, dayCell: dayCell, badgeLabelFor: date, badgeCount: badgeCount)
  }

  public func monthCollectionView(
    _ month: INFMonthCollectionView,
    dayCell: INFDayCell,
    backgroundImageFor date: Date,
    image: UIImage?
  ) -> UIImageView? {
    monthAppearanceDelegate?.monthCell(self, dayCell: dayCell, backgroundImageFor: date, image: image)
  }

}
