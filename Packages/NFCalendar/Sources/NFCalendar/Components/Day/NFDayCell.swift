//
//  NFDayCell.swift
//
//  Created by Makar Mishchenko on 13.08.2023.
//

import SnapKit
import SwiftDate
import UIKit

// MARK: - INFDayCell
public protocol INFDayCell: UICollectionViewCell {
  //  // MARK: - Properties
  var viewModel: INFDayCellViewModel? { get set }
  var dayAppearanceDelegate: INFDayCellAppearanceDelegate? { get set }
  // MARK: - UI
  var dateLabel: INFDayLabel { get }
  var badgeLabel: INFDayBadgeLabel { get }
  var backgroundImageView: INFDayBackgroundImageView { get }
  // MARK: - Methods
  func configure(_ data: NFCalendarDay)
  func setCellVisibility(isVisible: Bool)
}

// MARK: - NFDayCell
public class NFDayCell: UICollectionViewCell, INFDayCell {

  // MARK: - Public properties
  public var viewModel: INFDayCellViewModel? { didSet { viewModelDidSet() } }
  public weak var dayAppearanceDelegate: INFDayCellAppearanceDelegate? { didSet { dayAppearanceDelegateDidSet() } }

  public var dateLabel: INFDayLabel = BaseDateLabel()
  public var badgeLabel: INFDayBadgeLabel = BaseBadgeLabel()
  public var backgroundImageView: INFDayBackgroundImageView = BaseBackgroundImageView(frame: .zero)

  // MARK: - Init
  override public init(frame: CGRect) {
    super.init(frame: frame)

    initializeUI(dayData: .init(date: .now))
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public methods
  public func configure(_ dayData: NFCalendarDay) {
    viewModel?.date?.value = dayData.date
    dayAppearanceDelegate?.dayCell(
      self,
      setupDateLabel: dateLabel,
      ofDate: dayData.date
    )

    viewModel?.badgeCount?.value = dayData.badgeCount
    dayAppearanceDelegate?.dayCell(
      self,
      setupBadgeLabel: badgeLabel,
      ofDate: dayData.date,
      badgeCount: dayData.badgeCount
    )

    viewModel?.backgroundImage?.value = dayData.backgroundImage
    dayAppearanceDelegate?.dayCell(
      self,
      setupBackgroundImage: backgroundImageView,
      ofDate: dayData.date,
      image: dayData.backgroundImage
    )
  }

  public func setCellVisibility(isVisible: Bool) {
    isHidden = !isVisible
  }

}

// MARK: - Private UI methods
private extension NFDayCell {

  private func initializeUI(dayData: NFCalendarDay) {
    initDateLabel()
    initBadgeLabel()
    initBackgroundImageView()
  }

  private func resetDateLabel(newLabel: INFDayLabel) {
    dateLabel.removeFromSuperview()
    dateLabel.snp.removeConstraints()

    dateLabel = newLabel

    initDateLabel()
  }

  private func initDateLabel() {
    addSubview(dateLabel)

    dateLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func resetBadgeLabel(newLabel: INFDayBadgeLabel) {
    badgeLabel.removeFromSuperview()
    badgeLabel.snp.removeConstraints()

    badgeLabel = newLabel

    initBadgeLabel()
  }

  private func initBadgeLabel() {
    addSubview(badgeLabel)

    badgeLabel.snp.makeConstraints { make in
      make.width.height.greaterThanOrEqualTo(UIConstants.badgeLabelSize)
      make.top.equalTo(dateLabel.snp.top)
      make.trailing.equalTo(dateLabel.snp.trailing)
    }
  }

  private func resetBackgroundImageView(newImageView: INFDayBackgroundImageView) {
    backgroundImageView.removeFromSuperview()
    backgroundImageView.snp.removeConstraints()

    backgroundImageView = newImageView

    initBackgroundImageView()
  }

  private func initBackgroundImageView() {
    addSubview(backgroundImageView)

    backgroundImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.centerX.centerY.equalToSuperview()
    }
  }

  private func dayAppearanceDelegateDidSet() {
    if let components = dayAppearanceDelegate?.dayCellComponents(self) {
      setDayComponents(components: components)
    }
  }

  private func setDayComponents(components: NFDayComponents) {
    resetDateLabel(newLabel: components.dateLabel.init())
    resetBadgeLabel(newLabel: components.dateBadgeLabel.init())
    resetBackgroundImageView(newImageView: components.dateBackgroundImage.init())
  }

}

// MARK: - Private methods
private extension NFDayCell {

  private func viewModelDidSet() {
    bindViewModel()
  }

  private func bindViewModel() {
    guard let viewModel else { return }

    viewModel.date = .init(viewModel.date?.value ?? .now, valueChanged: { newDate in
      self.setDate(newDate)
    })

    viewModel.badgeCount = .init(viewModel.badgeCount?.value, valueChanged: { newBadgeCount in
      self.setBadgeCount(newBadgeCount)
    })

    viewModel.backgroundImage = .init(viewModel.backgroundImage?.value, valueChanged: { newImage in
      self.setBackgroundImage(newImage)
    })
  }

  private func setDate(_ date: Date) {
    dateLabel.text = Self.getFormattedDay(of: date)
  }

  private func setBadgeCount(_ count: Int?) {
    if let count {
      badgeLabel.isHidden = false
      badgeLabel.text = count > 9 ? String("9+") : String(count)
    } else {
      badgeLabel.text = ""
      badgeLabel.isHidden = true
    }
  }

  private func setBackgroundImage(_ image: UIImage?) {
    if let image {
      backgroundImageView.isHidden = false
      backgroundImageView.image = image
    } else {
      backgroundImageView.isHidden = true
      backgroundImageView.image = nil
    }
  }

}

// MARK: - Static
extension NFDayCell {

  enum UIConstants {
    static let badgeLabelSize = 16
  }

  private static let calendar = DateInRegion().calendar

  private static func getFormattedDay(of date: Date) -> String {
    date.toFormat("d")
  }

}

// MARK: - Base UI components
public extension NFDayCell {

  // MARK: - BaseDateLabel
  final class BaseDateLabel: UILabel, INFDayLabel {
    public var dayType: NFDayType = .defaultDate

    override init(frame: CGRect) {
      super.init(frame: frame)
      initialize()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    public func setDayType(_ dayType: NFDayType) {}

    func initialize() {
      textAlignment = .center
      layer.masksToBounds = true
      font = .systemFont(ofSize: 14)
      layer.zPosition = 1
    }

  }

  // MARK: - BaseBadgeLabel
  final class BaseBadgeLabel: UILabel, INFDayBadgeLabel {
    public var dayType: NFDayType = .defaultDate

    override init(frame: CGRect) {
      super.init(frame: frame)
      initialize()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubviews() {
      super.layoutSubviews()
      setCornerRadius()
    }

    public func setDayType(_ dayType: NFDayType) {}

    func initialize() {
      textAlignment = .center
      font = .systemFont(ofSize: 10, weight: .black)
      layer.zPosition = 2
      layer.cornerRadius = 12
    }

    private func setCornerRadius() {
      let radius = bounds.width / 2
      layer.cornerRadius = radius
    }

  }

  // MARK: - BaseBackgroundImageView
  final class BaseBackgroundImageView: UIImageView, INFDayBackgroundImageView {
    public var dayType: NFDayType = .defaultDate

    public func setDayType(_ dayType: NFDayType) {}
  }

}
