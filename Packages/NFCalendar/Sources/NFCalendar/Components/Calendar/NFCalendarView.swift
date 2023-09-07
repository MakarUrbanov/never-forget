import SwiftDate
import UIKit

public protocol INFCalendarView: UICollectionView {
  var viewModel: INFCalendarViewModel { get }

  var calendarDataSource: INFCalendarDataSource? { get set }
  var calendarDelegate: INFCalendarDelegate? { get set }
  var calendarAppearanceDelegate: INFCalendarAppearanceDelegate? { get set }

  init(viewModel: INFCalendarViewModel)

  func renderCalendar()
}

public final class NFCalendarView: UICollectionView, INFCalendarView {

  // MARK: - Public properties
  public let viewModel: INFCalendarViewModel
  // MARK: - Delegates
  public weak var calendarDataSource: INFCalendarDataSource?
  public weak var calendarDelegate: INFCalendarDelegate?
  public weak var calendarAppearanceDelegate: INFCalendarAppearanceDelegate?
  //  // MARK: - Private properties
  private var renderedMonthsData: [NFMonthData] = []
  private var diffableDataSource: UICollectionViewDiffableDataSource<Int, NFMonthData>?

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

    let monthsData = viewModel.generateMonthsData()
    var snapshot = diffableDataSource.snapshot()

    snapshot.appendSections([0])
    snapshot.appendItems(monthsData, toSection: 0)

    renderedMonthsData = monthsData
    diffableDataSource.apply(snapshot, animatingDifferences: false)
  }

}

// MARK: - Private methods
private extension NFCalendarView {
  private func getDiffableDataSource() -> UICollectionViewDiffableDataSource<Int, NFMonthData> {
    UICollectionViewDiffableDataSource(collectionView: self) { collectionView, indexPath, monthData in
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: Self.monthCellIdentifier,
        for: indexPath
      ) as? INFMonthCell else {
        fatalError("Failed dequeueReusableCell")
      }

      cell.monthDataSource = self
      cell.monthAppearanceDelegate = self
      cell.monthDelegate = self

      cell.renderMonthData(monthData)

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
    calendarAppearanceDelegate?.calendarView(self, dayCell: dayCell, dateLabelFor: date)
  }

  public func monthCell(
    _ month: INFMonthCell,
    dayCell: INFDayCell,
    badgeLabelFor date: Date,
    badgeCount: Int?
  ) -> UILabel? {
    calendarAppearanceDelegate?.calendarView(
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
    calendarAppearanceDelegate?.calendarView(self, dayCell: dayCell, backgroundImageFor: date, image: image)
  }

  public func monthCell(
    _ month: INFMonthCell,
    header: INFMonthHeader,
    labelForWeekday weekday: Int
  ) -> UILabel? {
    calendarAppearanceDelegate?.calendarView(self, header: header, labelForWeekday: weekday)
  }

  public func monthCell(
    _ month: INFMonthCell,
    header: INFMonthHeader,
    labelForMonth monthDate: Date
  ) -> UILabel? {
    calendarAppearanceDelegate?.calendarView(self, header: header, labelForMonth: monthDate)
  }

}

// MARK: - INFMonthCellDataSource
extension NFCalendarView: INFMonthCellDataSource {
  public func monthCellView(_ month: NFMonthCellView, dataFor date: Date) -> NFCalendarDay {
    calendarDataSource?.calendarView(self, dataFor: date) ?? .init(date: date)
  }
}

extension NFCalendarView: INFMonthCellDelegate {
  public func monthCollectionView(_ month: INFMonthCell, didSelect date: Date) {
    calendarDelegate?.calendar(self, didSelect: date)
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
    let monthData = renderedMonthsData[indexPath.item]
    let weeksInMonth = viewModel.numberOfWeeksInMonth(of: monthData.firstMonthDate)

    let height = (CGFloat(weeksInMonth) * collectionView.bounds.width / 7) + NFMonthCellView.headerHeight

    return .init(width: collectionView.bounds.width, height: height)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    calendarAppearanceDelegate?.calendarView(self, minimumLineSpacingForSectionAt: section) ?? 20
  }
}
