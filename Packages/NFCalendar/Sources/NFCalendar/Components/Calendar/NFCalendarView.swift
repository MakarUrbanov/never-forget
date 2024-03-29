import SwiftDate
import UIKit

public protocol INFCalendarView: UICollectionView {

  var viewModel: INFCalendarViewModel { get }
  var separatorColor: UIColor { get set }

  var calendarDataSource: INFCalendarDataSource? { get set }
  var calendarDelegate: INFCalendarDelegate? { get set }
  var calendarAppearanceDelegate: INFCalendarAppearanceDelegate? { get set }

  init(viewModel: INFCalendarViewModel)

  func renderCalendar()
}

public final class NFCalendarView: UICollectionView, INFCalendarView {

  // MARK: - Public properties
  public let viewModel: INFCalendarViewModel
  public var separatorColor: UIColor = .clear

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
      let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: Self.monthCellIdentifier,
        for: indexPath
      ) as! INFMonthCell


      cell.monthDataSource = self
      cell.datesAppearanceDelegate = self
      cell.monthHeaderAppearanceDelegate = self
      cell.monthDelegate = self

      let isLastItem = (self.diffableDataSource?.snapshot().itemIdentifiers.count ?? 0) - 1 == indexPath.item
      cell.separatorColor = self.separatorColor
      cell.separator.isHidden = isLastItem

      cell.renderMonthData(monthData)

      return cell
    }
  }
}

// MARK: - INFMonthCellAppearanceDelegate
extension NFCalendarView: INFDayCellAppearanceDelegate {

  public func dayCellComponents(_ dayCell: INFDayCell) -> NFDayComponents? {
    calendarAppearanceDelegate?.dayCellComponents(dayCell)
  }

  public func dayCell(_ dayCell: INFDayCell, setupDateLabel label: INFDayLabel, ofDate date: Date) {
    calendarAppearanceDelegate?.dayCell(dayCell, setupDateLabel: label, ofDate: date)
  }

  public func dayCell(
    _ dayCell: INFDayCell,
    setupBadgeLabel label: INFDayBadgeLabel,
    ofDate date: Date,
    badgeCount: Int?
  ) {
    calendarAppearanceDelegate?.dayCell(dayCell, setupBadgeLabel: label, ofDate: date, badgeCount: badgeCount)
  }

  public func dayCell(
    _ dayCell: INFDayCell,
    setupBackgroundImage imageView: INFDayBackgroundImageView,
    ofDate date: Date,
    image: UIImage?
  ) {
    calendarAppearanceDelegate?.dayCell(dayCell, setupBackgroundImage: imageView, ofDate: date, image: image)
  }

}

extension NFCalendarView: INFMonthHeaderAppearanceDelegate {

  public func monthHeader(
    _ header: INFMonthHeader,
    weekdaysView: INFMonthWeekdays,
    labelForWeekday weekday: Int
  ) -> UILabel? {
    calendarAppearanceDelegate?.monthHeader(header, weekdaysView: weekdaysView, labelForWeekday: weekday)
  }

  public func monthHeader(_ header: INFMonthHeader, labelForMonth monthDate: Date) -> UILabel? {
    calendarAppearanceDelegate?.monthHeader(header, labelForMonth: monthDate)
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

    let additionalOffset: CGFloat = 12
    let height = (CGFloat(weeksInMonth) * collectionView.bounds.width / 7) + NFMonthCellView.headerHeight

    return .init(width: collectionView.bounds.width, height: height + additionalOffset)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    calendarAppearanceDelegate?.calendarView(self, minimumLineSpacingForSectionAt: section) ?? 20
  }

}
