//
//  NFMonthCellView.swift
//
//
//  Created by Makar Mishchenko on 14.08.2023.
//

import SnapKit
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

  public func renderMonth(_ date: Date) {
    setupViews()

    let days = NFMonthCellView.getMonthDays(of: date)

    monthHeaderView.configure(with: date)
    monthCollectionView.setupMonthDates(days)
  }

}

// MARK: - INFMonthCollectionViewDataSource
extension NFMonthCellView: INFMonthCollectionViewDataSource {

  public func monthCollectionView(_ month: INFMonthCollectionView, dataFor: Date) -> NFCalendarDay {
    return monthDataSource?.monthCellView(self, dataFor: dataFor) ?? .init(
      date: dataFor,
      backgroundImage: nil,
      badgeCount: nil
    )
  }
}

// MARK: - Private
extension NFMonthCellView {

  private func setupViews() {
    setupMonthHeaderView()
    setupMonthView()
  }

  private func setupMonthHeaderView() {
    addSubview(monthHeaderView)

    monthHeaderView.snp.makeConstraints { make in
      make.height.equalTo(NFMonthCellView.headerHeight)
      make.leading.top.trailing.equalToSuperview()
    }

    monthHeaderView.appearanceDelegate = self
  }

  private func setupMonthView() {
    addSubview(monthCollectionView)

    monthCollectionView.snp.makeConstraints { make in
      make.leading.bottom.trailing.equalToSuperview()
      make.top.equalTo(monthHeaderView.snp.bottom)
    }

    monthCollectionView.appearanceDelegate = self
    monthCollectionView.monthDataSource = self
  }

}

// MARK: - Static
extension NFMonthCellView {

  public static let headerHeight: CGFloat = 80

  private static func getDaysInMonth(of date: Date) -> Int {
    Calendar.current.range(of: .day, in: .month, for: date)!.upperBound - 1
  }

  private static func getFirstDateOfMonth(of date: Date) -> Date {
    let components = Calendar.current.dateComponents([.year, .month], from: date)

    return Calendar.current.date(from: components)!
  }

  private static func getMonthDays(of date: Date) -> [Date] {
    let daysInMonth = NFMonthCellView.getDaysInMonth(of: date)
    let firstDayOfMonth = NFMonthCellView.getFirstDateOfMonth(of: date)
    var daysList: [Date] = []

    for day in 0..<daysInMonth {
      let newDate = Calendar.current.date(bySetting: .day, value: 1 + day, of: firstDayOfMonth)!
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
    labelForWeekday weekday: String
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
