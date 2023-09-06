import SwiftDate
import UIKit

public protocol INFCalendarView: UICollectionView {
  var viewModel: INFCalendarViewModel { get }

  init(viewModel: INFCalendarViewModel)

  func renderCalendar()
}

public final class NFCalendarView: UICollectionView, INFCalendarView {

  // MARK: - Public properties
  public let viewModel: INFCalendarViewModel

  //  // MARK: - Private properties
  private var renderedMonths: [Date] = []
  private var diffableDataSource: UICollectionViewDiffableDataSource<Int, Date>?

  // MARK: - Init
  public init(viewModel: INFCalendarViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    delegate = self
    register(NFMonthCellView.self, forCellWithReuseIdentifier: Self.monthCellIdentifier)
    diffableDataSource = getDiffableDataSource()
    dataSource = diffableDataSource
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public properties
  public func renderCalendar() {
    guard let diffableDataSource else { fatalError("diffableDataSource could be initialised") }

    let months = viewModel.generateMonths()
    var snapshot = diffableDataSource.snapshot()

    snapshot.appendSections([0])
    snapshot.appendItems(months, toSection: 0)

    renderedMonths = months
    diffableDataSource.apply(snapshot, animatingDifferences: false)
  }

}

// MARK: - Private methods
private extension NFCalendarView {
  private func getDiffableDataSource() -> UICollectionViewDiffableDataSource<Int, Date> {
    UICollectionViewDiffableDataSource(collectionView: self) { collectionView, indexPath, date in
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: Self.monthCellIdentifier,
        for: indexPath
      ) as? INFMonthCell else {
        fatalError("Failed dequeueReusableCell")
      }

      cell.monthDataSource = self
      cell.monthAppearanceDelegate = self
      cell.monthDelegate = self

      cell.renderMonth(date)

      return cell
    }
  }
}

// MARK: - INFMonthCellAppearanceDelegate
extension NFCalendarView: INFMonthCellAppearanceDelegate {

  public func monthCell(
    _ month: INFMonthCell,
    dayCell: INFDayCell,
    dateLabelFor date: Date
  ) -> UILabel? {
    viewModel.calendarAppearanceDelegate?.calendarView(self, dayCell: dayCell, dateLabelFor: date)
  }

  public func monthCell(
    _ month: INFMonthCell,
    dayCell: INFDayCell,
    badgeLabelFor date: Date,
    badgeCount: Int?
  ) -> UILabel? {
    viewModel.calendarAppearanceDelegate?.calendarView(
      self,
      dayCell: dayCell,
      badgeLabelFor: date,
      badgeCount: badgeCount
    )
  }

  public func monthCell(
    _ month: INFMonthCell,
    dayCell: INFDayCell,
    backgroundImageFor date: Date,
    image: UIImage?
  ) -> UIImageView? {
    viewModel.calendarAppearanceDelegate?.calendarView(self, dayCell: dayCell, backgroundImageFor: date, image: image)
  }

  public func monthCell(
    _ month: INFMonthCell,
    header: INFMonthHeader,
    labelForWeekday weekday: Int
  ) -> UILabel? {
    viewModel.calendarAppearanceDelegate?.calendarView(self, header: header, labelForWeekday: weekday)
  }

  public func monthCell(
    _ month: INFMonthCell,
    header: INFMonthHeader,
    labelForMonth monthDate: Date
  ) -> UILabel? {
    viewModel.calendarAppearanceDelegate?.calendarView(self, header: header, labelForMonth: monthDate)
  }

}

// MARK: - INFMonthCellDataSource
extension NFCalendarView: INFMonthCellDataSource {
  public func monthCellView(_ month: NFMonthCellView, dataFor date: Date) -> NFCalendarDay {
    viewModel.calendarDataSource?.calendarView(self, dataFor: date) ?? .init(date: date)
  }
}

extension NFCalendarView: INFMonthCellDelegate {
  public func monthCollectionView(_ month: INFMonthCell, didSelect date: Date) {
    viewModel.calendarDelegate?.calendar(self, didSelect: date)
  }
}

// MARK: - Static
extension NFCalendarView {
  // MARK: - Static properties
  private static let monthCellIdentifier = String(describing: NFCalendarView.self)
}

// MARK: - UICollectionViewFlowLayout, UICollectionViewDelegate
extension NFCalendarView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let date = renderedMonths[indexPath.item]
    let weeksInMonth = viewModel.numberOfWeeksInMonth(of: date)

    let height = (CGFloat(weeksInMonth) * collectionView.bounds.width / 7) + NFMonthCellView.headerHeight

    return .init(width: collectionView.bounds.width, height: height)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    viewModel.calendarAppearanceDelegate?.calendarView(self, minimumLineSpacingForSectionAt: section) ?? 20
  }
}
