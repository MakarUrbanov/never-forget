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
  var datesAppearanceDelegate: INFDayCellAppearanceDelegate? { get set }
  var monthDelegate: INFMonthCollectionViewDelegate? { get set }

  // MARK: - Init
  init(viewModel: INFMonthCollectionViewModel)

  // MARK: - Methods
  func setupMonthData(_ monthData: NFMonthData)
}

public class NFMonthCollectionView: UICollectionView, INFMonthCollectionView {
  // MARK: - Public properties
  public var viewModel: INFMonthCollectionViewModel
  // MARK: - Delegates
  public weak var monthDataSource: INFMonthCollectionViewDataSource?
  public weak var datesAppearanceDelegate: INFDayCellAppearanceDelegate?
  public weak var monthDelegate: INFMonthCollectionViewDelegate?

  // MARK: - Init
  public required init(viewModel: INFMonthCollectionViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    register(NFDayCell.self, forCellWithReuseIdentifier: NFMonthCollectionView.dayCellIdentifier)

    backgroundColor = .clear
    dataSource = self
    delegate = self

    isScrollEnabled = false
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public methods
  public func setupMonthData(_ monthData: NFMonthData) {
    setNewFirstMonthDate(monthData.firstMonthDate)
    setNewDates(monthData.monthDates)
  }

}

// MARK: - Private methods
private extension NFMonthCollectionView {

  private func setNewDates(_ dates: [Date]) {
    viewModel.dates = .init(dates, valueChanged: { [self] _ in
      reloadData()
    })
  }

  private func setNewFirstMonthDate(_ date: Date) {
    viewModel.firstMonthDate = .init(date)
  }

}

// MARK: - UICollectionViewDataSource
extension NFMonthCollectionView: UICollectionViewDataSource {

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    viewModel.dates.value.count
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: NFMonthCollectionView.dayCellIdentifier,
        for: indexPath
      ) as? INFDayCell,
      let firstMonthsDate = viewModel.firstMonthDate?.value else
    {
      fatalError("Failed getDiffableDataSource")
    }

    let day = viewModel.dates.value[indexPath.item]
    let isEmptyCell = !viewModel.areDatesInSameMonthAndYear(date1: day, date2: firstMonthsDate)

    if isEmptyCell {
      cell.setCellVisibility(isVisible: false)
    } else {
      if cell.dayAppearanceDelegate == nil {
        cell.dayAppearanceDelegate = self
      }

      cell.viewModel = NFDayCellViewModel()

      guard let data = monthDataSource?.monthCollectionView(self, dataFor: day) else {
        fatalError("Has no day data")
      }

      cell.configure(data)
      cell.setCellVisibility(isVisible: true)
    }

    return cell
  }
}

// MARK: - INFDayCellAppearanceDelegate
extension NFMonthCollectionView: INFDayCellAppearanceDelegate {

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

// MARK: - UICollectionViewDelegateFlowLayout
extension NFMonthCollectionView: UICollectionViewDelegate {

  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedDate = viewModel.dates.value[indexPath.item]
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
