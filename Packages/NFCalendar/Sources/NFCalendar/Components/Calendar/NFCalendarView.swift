import UIKit

public protocol INFCalendarView: UIView {
  var calendarDataSource: INFCalendarDataSource? { get set }
  var calendarDelegate: INFCalendarDelegate? { get set }
  var calendarAppearanceDelegate: INFCalendarAppearanceDelegate? { get set }

  init()

  func renderCalendar()
}

public final class NFCalendarView: UICollectionView, INFCalendarView {

  // MARK: - Public properties
  public weak var calendarDataSource: INFCalendarDataSource?
  public weak var calendarDelegate: INFCalendarDelegate?
  public weak var calendarAppearanceDelegate: INFCalendarAppearanceDelegate?

  // MARK: - Private properties
  private var renderedMonths: [Date] = []
  private var diffableDataSource: UICollectionViewDiffableDataSource<Section, Date>?
//  private var viewModel: INFCalendarViewModel

  // MARK: - Init
  public init() {
//    viewModel = NFCalendarViewModel()

    super.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    delegate = self

    register(NFMonthCellView.self, forCellWithReuseIdentifier: NFCalendarView.monthCellIdentifier)

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

    let months = generateMonths()
    var snapshot = diffableDataSource.snapshot()

    snapshot.appendSections([.main])
    snapshot.appendItems(months, toSection: .main)

    renderedMonths = months
    diffableDataSource.apply(snapshot, animatingDifferences: false)
  }

}

// MARK: - Private methods
private extension NFCalendarView {

  private func generateMonths() -> [Date] {
    let startFromComponents = Calendar.current.dateComponents([.year, .month], from: NFCalendarView.renderFromDate)
    let startFrom = Calendar.current.date(from: startFromComponents)!
    var months: [Date] = []

    for monthNumber in 0..<NFCalendarView.numberOfRenderMonths {
      let monthDate = Calendar.current.date(byAdding: .month, value: monthNumber, to: startFrom)!
      months.append(monthDate)
    }

    return months
  }

  private func getDiffableDataSource() -> UICollectionViewDiffableDataSource<Section, Date> {
    UICollectionViewDiffableDataSource(collectionView: self) { collectionView, indexPath, date in
      guard let cell = collectionView.dequeueReusableCell(
        withReuseIdentifier: NFCalendarView.monthCellIdentifier,
        for: indexPath
      ) as? INFMonthCell else {
        fatalError("Failed dequeueReusableCell")
      }

      cell.monthDataSource = self
      cell.monthAppearanceDelegate = self

      cell.renderMonth(date)

      return cell
    }
  }

}

// MARK: - INFMonthCellAppearanceDelegate
extension NFCalendarView: INFMonthCellAppearanceDelegate {

  public func monthCell(_ month: INFMonthCell, dayCell: INFDayCell, dateLabelFor date: Date) -> UILabel? {
    calendarAppearanceDelegate?.calendarView(self, dayCell: dayCell, dateLabelFor: date)
  }

  public func monthCell(
    _ month: INFMonthCell,
    dayCell: INFDayCell,
    badgeLabelFor date: Date,
    badgeCount: Int?
  ) -> UILabel? {
    calendarAppearanceDelegate?.calendarView(self, dayCell: dayCell, badgeLabelFor: date, badgeCount: badgeCount)
  }

  public func monthCell(
    _ month: INFMonthCell,
    dayCell: INFDayCell,
    backgroundImageFor date: Date,
    image: UIImage?
  ) -> UIImageView? {
    calendarAppearanceDelegate?.calendarView(self, dayCell: dayCell, backgroundImageFor: date, image: image)
  }

  public func monthCell(_ month: INFMonthCell, header: INFMonthHeader, labelForWeekday weekday: String) -> UILabel? {
    calendarAppearanceDelegate?.calendarView(self, header: header, labelForWeekday: weekday)
  }

  public func monthCell(_ month: INFMonthCell, header: INFMonthHeader, labelForMonth monthDate: Date) -> UILabel? {
    calendarAppearanceDelegate?.calendarView(self, header: header, labelForMonth: monthDate)
  }

}

// MARK: - INFMonthCellDataSource
extension NFCalendarView: INFMonthCellDataSource {

  public func monthCellView(_ month: NFMonthCellView, dataFor date: Date) -> NFCalendarDay {
    calendarDataSource?.calendarView(self, dataFor: date) ?? .init(date: date)
  }

}

// MARK: - Static
extension NFCalendarView {

  // MARK: - Static properties
  private static let monthCellIdentifier = String(describing: NFCalendarView.self)
  private static let renderFromDate: Date = .now
  private static let numberOfRenderMonths: Int = 12

  // MARK: - Static methods
  private static func numberOfWeeksInMonth(of date: Date) -> Int? {
    guard let range = Calendar.current.range(of: .weekOfMonth, in: .month, for: date) else {
      return nil
    }

    return range.count
  }

}

// MARK: - UICollectionViewFlowLayout, UICollectionViewDelegate
extension NFCalendarView: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let date = renderedMonths[indexPath.item]
    let weeksInMonth = NFCalendarView.numberOfWeeksInMonth(of: date) ?? 4

    let height = (CGFloat(weeksInMonth) * collectionView.bounds.width / 7) + NFMonthCellView.headerHeight

    return .init(width: collectionView.bounds.width, height: height)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    20 // TODO: mmk layout delegate
  }

}

// MARK: - Models
extension NFCalendarView {

  private enum Section {
    case main
  }

}
