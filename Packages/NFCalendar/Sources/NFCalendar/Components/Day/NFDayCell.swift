//
//  NFDayCell.swift
//
//  Created by Makar Mishchenko on 13.08.2023.
//

import SnapKit
import UIKit

// MARK: - INFDayCell
public protocol INFDayCell: UICollectionViewCell {
  // MARK: - Properties
  var date: Date { get }
  var badgeCount: Int? { get }
  var backgroundImage: UIImage? { get }

  var dayAppearanceDelegate: INFDayCellAppearanceDelegate? { get set }
  // MARK: - UI
  var dateLabel: UILabel { get }
  var badgeLabel: UILabel { get }
  var backgroundImageView: UIImageView { get }
  // MARK: - Methods
  func setupView(_ data: NFCalendarDay)
  func setCellVisibility(isVisible: Bool)
}

// MARK: - NFDayCell
public class NFDayCell: UICollectionViewCell, INFDayCell {
  // MARK: - Public properties
  public private(set) var date: Date = .now
  public private(set) var badgeCount: Int?
  public private(set) var backgroundImage: UIImage?

  public weak var dayAppearanceDelegate: INFDayCellAppearanceDelegate?

  public private(set) var backgroundImageView = UIImageView(frame: .zero)
  public private(set) var dateLabel: UILabel = BaseDateLabel()
  public private(set) var badgeLabel: UILabel = BaseBadgeLabel()

  // MARK: - Init
  override public init(frame: CGRect) {
    super.init(frame: frame)

    initialize()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public methods
  public func setupView(_ dayData: NFCalendarDay) {
    setupDateLabel(for: dayData.date)
    setDate(dayData.date)

    setupBadgeLabel(for: dayData.date, with: dayData.badgeCount)
    setBadgeCount(dayData.badgeCount)

    setupBackgroundImageView(for: dayData.date, with: dayData.backgroundImage)
    setBackgroundImage(dayData.backgroundImage)
  }

  public func setCellVisibility(isVisible: Bool) {
    isHidden = !isVisible
  }

}

// MARK: - Private methods
private extension NFDayCell {

  private func initialize() {
    setupDateLabel(for: nil)
    setupBadgeLabel(for: nil, with: nil)
    setupBackgroundImageView(for: nil, with: nil)
  }

  private func setupDateLabel(for date: Date?) {
    if let date, let dateLabelFromDelegate = dayAppearanceDelegate?.dayCell(self, dateLabelFor: date) {
      dateLabel.removeFromSuperview()
      dateLabel = dateLabelFromDelegate
    }

    addSubview(dateLabel)

    dateLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func setupBadgeLabel(for date: Date?, with badgeCount: Int?) {
    if let date, let badgeLabelFromDelegate = dayAppearanceDelegate?.dayCell(
      self,
      badgeLabelFor: date,
      badgeCount: badgeCount
    ) {
      badgeLabel.removeFromSuperview()
      badgeLabel = badgeLabelFromDelegate
    }
    addSubview(badgeLabel)

    badgeLabel.snp.makeConstraints { make in
//      make.width.height.equalTo(self.snp.width).dividedBy(2.5)
//      make.top.equalTo(dateLabel.snp.top)
//      make.trailing.equalTo(dateLabel.snp.trailing)
      make.edges.equalToSuperview()
    }
  }

  private func setupBackgroundImageView(for date: Date?, with image: UIImage?) {
    if let date, let backgroundImageFromDelegate = dayAppearanceDelegate?.dayCell(
      self,
      backgroundImageFor: date,
      image: image
    ) {
      backgroundImageView.removeFromSuperview()
      backgroundImageView = backgroundImageFromDelegate
    }
    addSubview(backgroundImageView)

    backgroundImageView.snp.makeConstraints { make in
//      make.edges.equalToSuperview()
//      make.centerX.centerY.equalToSuperview()
      make.edges.equalToSuperview()
    }
  }

  private func setDate(_ date: Date) {
    self.date = date
    dateLabel.text = NFDayCell.getFormattedDay(of: date)
  }

  private func setBadgeCount(_ count: Int?) {
    if let count {
      badgeLabel.isHidden = false
      badgeCount = count
      badgeLabel.text = count > 9 ? String("9+") : String(count)
    } else {
      badgeCount = nil
      badgeLabel.text = ""
      badgeLabel.isHidden = true
    }
  }

  private func setBackgroundImage(_ image: UIImage?) {
    if let image {
      backgroundImageView.isHidden = false
      backgroundImage = image
      backgroundImageView.image = backgroundImage
    } else {
      backgroundImageView.isHidden = true
      backgroundImage = nil
      backgroundImageView.image = nil
    }
  }

}

// MARK: - Static
extension NFDayCell {

  // MARK: - Static methods
  private static func getFormattedDay(of date: Date) -> String {
    String(Calendar.current.component(.day, from: date))
  }

//  private static func compareDates(date1: Date, date2: Date) -> Bool {
//    let dateFormat = DateFormatter.yearMonthDayFormat
//    let day1String = DateFormatter.string(dateFormat: dateFormat, from: date1)
//    let day2String = DateFormatter.string(dateFormat: dateFormat, from: date2)
//
//    return day1String == day2String
//  }
//
//  private static func isDateToday(_ date: Date) -> Bool {
//    NFDayCollectionViewCell.compareDates(date1: Date.now, date2: date)
//  }
//
//  private static func isDateYesterdayOrEarlier(date: Date) -> Bool {
//    let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
//    return date < yesterday
//  }
//
//  private static func defineTypeOfDay(_ dayData: NFCalendarDayData, isDateSelected: Bool) -> NFDayType {
//    let date = dayData.date
//
//    if isDateSelected {
//      return .selectedDay
//    }
//
//    let isTodayDate = NFDayCollectionViewCell.isDateToday(date)
//    if isTodayDate {
//      return .todayDay
//    }
//
//    let isPastDay = NFDayCollectionViewCell.isDateYesterdayOrEarlier(date: date)
//    if isPastDay {
//      return .pastDay
//    }
//
//    return .defaultDay
//  }

}

// MARK: - UI components
public extension NFDayCell {

  // MARK: - BaseDateLabel
  final class BaseDateLabel: UILabel {

    override init(frame: CGRect) {
      super.init(frame: frame)
      initialize()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    func initialize() {
      textAlignment = .center
      layer.masksToBounds = true
      font = .systemFont(ofSize: 14)
      layer.zPosition = 1
    }

  }

  // MARK: - BaseBadgeLabel
  final class BaseBadgeLabel: UILabel {

    override init(frame: CGRect) {
      super.init(frame: frame)
      initialize()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides
    override public func layoutSubviews() {
      super.layoutSubviews()
      setCornerRadius()
    }

    // MARK: - Public methods
    func initialize() {
      textAlignment = .center
      font = .systemFont(ofSize: 10, weight: .black)
      layer.zPosition = 2
      layer.cornerRadius = 12
    }

    // MARK: - Private methods
    private func setCornerRadius() {
      let radius = bounds.width / 2
      layer.cornerRadius = radius
    }

  }

}
