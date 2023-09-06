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
  var viewModel: INFMonthCollectionViewModel { get }
  // MARK: - Delegates
  var monthDataSource: INFMonthCollectionViewDataSource? { get set }
  var appearanceDelegate: INFMonthCollectionViewAppearanceDelegate? { get set }
  var monthDelegate: INFMonthCollectionViewDelegate? { get set }

  // MARK: - Init
  init(viewModel: INFMonthCollectionViewModel)

  // MARK: - Methods
  func setupMonthDates(_ dates: [Date])
}

public class NFMonthCollectionView: UICollectionView, INFMonthCollectionView {
  // MARK: - Public properties
  public var viewModel: INFMonthCollectionViewModel
  // MARK: - Delegates
  public weak var monthDataSource: INFMonthCollectionViewDataSource?
  public weak var appearanceDelegate: INFMonthCollectionViewAppearanceDelegate?
  public weak var monthDelegate: INFMonthCollectionViewDelegate?

  // MARK: - Private properties
  private var diffableDataSource: UICollectionViewDiffableDataSource<Int, Date>?
  private var datesWithEmptyCells: [Date] = []

  // MARK: - Init
  public required init(viewModel: INFMonthCollectionViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    register(NFDayCell.self, forCellWithReuseIdentifier: NFMonthCollectionView.dayCellIdentifier)

    backgroundColor = .clear
    diffableDataSource = getDiffableDataSource()
    initialiseDiffableDataSource()
    dataSource = diffableDataSource
    delegate = self

    isScrollEnabled = false
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public methods
  public func setupMonthDates(_ dates: [Date]) {
    if let firstDate = dates.first {
      setNewFirstMonthDate(firstDate)
    }

    setNewDates(dates)
  }

}

// MARK: - Private methods
private extension NFMonthCollectionView {

  private func setNewDates(_ dates: [Date]) {
    viewModel.dates = .init(dates, valueChanged: { [self] newDates in
      updateMonthDates(newDates)
    })
  }

  private func setNewFirstMonthDate(_ date: Date) {
    viewModel.firstMonthDate = .init(date)
  }

  private func getDiffableDataSource() -> UICollectionViewDiffableDataSource<Int, Date> {
    UICollectionViewDiffableDataSource(collectionView: self) { [self] collectionView, indexPath, day in
      guard
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: NFMonthCollectionView.dayCellIdentifier,
          for: indexPath
        ) as? INFDayCell,
        let firstMonthsDate = viewModel.firstMonthDate?.value else
      {
        fatalError("Failed getDiffableDataSource")
      }

      let isEmptyCell = !viewModel.areDatesInSameMonthAndYear(date1: day, date2: firstMonthsDate)

      if isEmptyCell {
        cell.setCellVisibility(isVisible: false)
      } else {
        cell.dayAppearanceDelegate = self
        cell.viewModel = NFDayCellViewModel()

        guard let data = monthDataSource?.monthCollectionView(self, dataFor: day) else {
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
    snapshot.appendSections([0])
    snapshot.appendItems([], toSection: 0)
    diffableDataSource.apply(snapshot, animatingDifferences: false)
  }

  private func updateMonthDates(_ newDates: [Date]) {
    guard let diffableDataSource else { fatalError("diffableDataSource could be initialised") }

    var snapshot = diffableDataSource.snapshot()

    if snapshot.sectionIdentifiers.count > 0 {
      snapshot.deleteAllItems()
      snapshot.appendSections([0])
    }

    guard let firstMonthDate = viewModel.firstMonthDate?.value else {
      fatalError("Something went wrong. firstMonthsDate must be initialized")
    }

    let datesWithEmptyCells = viewModel.getListOfPastAndFutureDatesOfMonth(
      dates: newDates,
      firstMonthsDate: firstMonthDate
    )
    snapshot.appendItems(datesWithEmptyCells, toSection: 0)
    diffableDataSource.apply(snapshot, animatingDifferences: false)

    self.datesWithEmptyCells = datesWithEmptyCells
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
extension NFMonthCollectionView: UICollectionViewDelegate {

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedDate = datesWithEmptyCells[indexPath.item]
    monthDelegate?.monthCollectionView(self, didSelect: selectedDate)
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

// MARK: - Static
extension NFMonthCollectionView {

  // MARK: - Static properties
  private static let dayCellIdentifier = String(describing: NFMonthCollectionView.self)
  public static let dateCellsPadding: CGFloat = 8

}
