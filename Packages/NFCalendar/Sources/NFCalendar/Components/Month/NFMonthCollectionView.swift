//
//  NFMonthCollectionView.swift
//
//
//  Created by Makar Mishchenko on 14.08.2023.
//

import SnapKit
import SwiftDate
import UIKit

// MARK: - INFMonthCollectionView
public protocol INFMonthCollectionView: UICollectionView {
  // MARK: - Static
  static var dateCellsPadding: CGFloat { get }
  // MARK: - Properties
  var firstMonthsDate: Date? { get }
  var dates: [Date] { get }
  // MARK: - Delegates
  var monthDataSource: INFMonthCollectionViewDataSource? { get set }
  var appearanceDelegate: INFMonthCollectionViewAppearanceDelegate? { get set }
  // MARK: - Methods
  func setupMonthDates(_ dates: [Date])
}

public class NFMonthCollectionView: UICollectionView, INFMonthCollectionView {

  // MARK: - Public properties
  public private(set) var firstMonthsDate: Date?
  public private(set) var dates: [Date] = []
  // MARK: - Delegates
  public weak var monthDataSource: INFMonthCollectionViewDataSource?
  public weak var appearanceDelegate: INFMonthCollectionViewAppearanceDelegate?

  // MARK: - Private properties
  private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Date>?

  // MARK: - Init
  override public init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)

    register(NFDayCell.self, forCellWithReuseIdentifier: NFMonthCollectionView.dayCellIdentifier)

    backgroundColor = .clear
    diffableDataSource = getDiffableDataSource()
    initialiseDiffableDataSource()
    dataSource = diffableDataSource
    delegate = self
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public methods
  public func setupMonthDates(_ dates: [Date]) {
    if let firstDate = dates.first {
      firstMonthsDate = firstDate
    }

    self.dates = dates

    updateMonthDates()
  }

}

// MARK: - Static
extension NFMonthCollectionView {

  // MARK: - Static properties
  private static let dayCellIdentifier = String(describing: NFMonthCollectionView.self)
  public static let dateCellsPadding: CGFloat = 8
  private static let calendar = DateInRegion().calendar

  // MARK: - Static methods
  private static func areDatesInSameMonthAndYear(date1: Date, date2: Date) -> Bool {
    let componentsOfDate1 = calendar.dateComponents([.year, .month], from: date1)
    let componentsOfDate2 = calendar.dateComponents([.year, .month], from: date2)

    return componentsOfDate1.year == componentsOfDate2.year && componentsOfDate1.month == componentsOfDate2.month
  }

  private static func getListOfPastAndFutureDatesOfMonth(dates: [Date], firstMonthsDate: Date) -> [Date] {
    let systemFirstWeekday = calendar.firstWeekday

    let weekdayOfFirstDay = calendar.component(.weekday, from: firstMonthsDate)
    let pastDatesShift: Int = (weekdayOfFirstDay - systemFirstWeekday + 7) % 7
    let pastDates: [Date] = (0..<pastDatesShift).reversed().compactMap {
      calendar.date(byAdding: .day, value: -$0 - 1, to: firstMonthsDate)
    }

    return pastDates + dates
  }

}

// MARK: - Private methods
private extension NFMonthCollectionView {

  private func getDiffableDataSource() -> UICollectionViewDiffableDataSource<Section, Date> {
    UICollectionViewDiffableDataSource(collectionView: self) { collectionView, indexPath, day in
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: NFMonthCollectionView.dayCellIdentifier,
        for: indexPath
      ) as? INFDayCell else {
        fatalError("Failed dequeueReusableCell")
      }

      cell.dayAppearanceDelegate = self

      guard let firstMonthsDate = self.firstMonthsDate else {
        fatalError("Something went wrong. firstMonthsDate must be initialized")
      }

      let isEmptyCell = !NFMonthCollectionView.areDatesInSameMonthAndYear(date1: day, date2: firstMonthsDate)

      if isEmptyCell {
        cell.setCellVisibility(isVisible: false)
      } else {
        guard let data = self.monthDataSource?.monthCollectionView(self, dataFor: day) else {
          fatalError("Has no day data")
        }

        cell.setupView(data)
        cell.setCellVisibility(isVisible: true)
      }

      return cell
    }
  }

  private func initialiseDiffableDataSource() {
    guard let diffableDataSource else { fatalError("diffableDataSource could be initialised") }

    var snapshot = diffableDataSource.snapshot()
    snapshot.appendSections([.main])
    snapshot.appendItems([], toSection: .main)
    diffableDataSource.apply(snapshot, animatingDifferences: false)
  }

  private func updateMonthDates() {
    guard let diffableDataSource else { fatalError("diffableDataSource could be initialised") }

    var snapshot = diffableDataSource.snapshot()

    if snapshot.sectionIdentifiers.count > 0 {
      snapshot.deleteAllItems()
      snapshot.appendSections([.main])
    }

    guard let firstMonthsDate else {
      fatalError("Something went wrong. firstMonthsDate must be initialized")
    }

    let datesWithEmptyCells = NFMonthCollectionView.getListOfPastAndFutureDatesOfMonth(
      dates: dates,
      firstMonthsDate: firstMonthsDate
    )
    snapshot.appendItems(datesWithEmptyCells, toSection: .main)
    diffableDataSource.apply(snapshot, animatingDifferences: false)
  }

}

// MARK: - INFDayCellAppearanceDelegate
extension NFMonthCollectionView: INFDayCellAppearanceDelegate {

  public func dayCell(_ dayCell: INFDayCell, dateLabelFor date: Date) -> UILabel? {
    appearanceDelegate?.monthCollectionView(self, dayCell: dayCell, dateLabelFor: date)
  }

  public func dayCell(_ dayCell: INFDayCell, badgeLabelFor date: Date, badgeCount: Int?) -> UILabel? {
    appearanceDelegate?.monthCollectionView(self, dayCell: dayCell, badgeLabelFor: date, badgeCount: badgeCount)
  }

  public func dayCell(_ dayCell: INFDayCell, backgroundImageFor date: Date, image: UIImage?) -> UIImageView? {
    appearanceDelegate?.monthCollectionView(self, dayCell: dayCell, backgroundImageFor: date, image: image)
  }

}

// MARK: - UICollectionViewDelegateFlowLayout
extension NFMonthCollectionView: UICollectionViewDelegateFlowLayout {

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let itemsCount: CGFloat = 7
    let padding = NFMonthCollectionView.dateCellsPadding
    let size = collectionView.bounds.width / itemsCount - padding
    let safeSize = size <= 0 ? 40 : size

    return .init(width: safeSize, height: safeSize)
  }

  // TODO: mmk вынести. DI
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    NFMonthCollectionView.dateCellsPadding
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    .zero
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumInteritemSpacingForSectionAt section: Int
  ) -> CGFloat {
    NFMonthCollectionView.dateCellsPadding
  }

}

// MARK: - Models
extension NFMonthCollectionView {

  private enum Section {
    case main
  }

}
