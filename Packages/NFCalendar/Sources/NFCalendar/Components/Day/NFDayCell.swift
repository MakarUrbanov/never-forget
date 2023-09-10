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
  var dateLabel: UILabel { get }
  var badgeLabel: UILabel { get }
  var backgroundImageView: UIImageView { get }
  // MARK: - Methods
  func setupView(_ data: NFCalendarDay)
  func setCellVisibility(isVisible: Bool)
}

// MARK: - NFDayCell
public class NFDayCell: UICollectionViewCell, INFDayCell {

//  // MARK: - Public properties
  public var viewModel: INFDayCellViewModel?

  public weak var dayAppearanceDelegate: INFDayCellAppearanceDelegate?

  public private(set) var backgroundImageView = UIImageView(frame: .zero)
  public private(set) var dateLabel: UILabel = BaseDateLabel()
  public private(set) var badgeLabel: UILabel = BaseBadgeLabel()

  // MARK: - Public methods
  public func setupView(_ dayData: NFCalendarDay) {
    setupDateLabel(for: dayData.date)
    setupBadgeLabel(for: dayData.date, with: dayData.badgeCount)
    setupBackgroundImageView(for: dayData.date, with: dayData.backgroundImage)

    setDayData(dayData)
  }

  public func setCellVisibility(isVisible: Bool) {
    isHidden = !isVisible
  }

}

// MARK: - Private methods
private extension NFDayCell {

  private func setDayData(_ dayData: NFCalendarDay) {
    guard let viewModel else { return }

    viewModel.date = .init(dayData.date, valueChanged: { newDate in
      self.updateDateView(newDate)
    })

    viewModel.badgeCount = .init(dayData.badgeCount, valueChanged: { newBadgeCount in
      self.updateBadgeCountView(newBadgeCount)
    })

    viewModel.backgroundImage = .init(dayData.backgroundImage, valueChanged: { newImage in
      self.updateBackgroundImageView(newImage)
    })
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
      make.width.height.equalTo(UIConstants.badgeLabelSize)
      make.top.equalTo(dateLabel.snp.top)
      make.trailing.equalTo(dateLabel.snp.trailing)
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
      make.edges.equalToSuperview()
      make.centerX.centerY.equalToSuperview()
    }
  }

  private func updateDateView(_ date: Date) {
    dateLabel.text = Self.getFormattedDay(of: date)
  }

  private func updateBadgeCountView(_ count: Int?) {
    if let count {
      badgeLabel.isHidden = false
      badgeLabel.text = count > 9 ? String("9+") : String(count)
    } else {
      badgeLabel.text = ""
      badgeLabel.isHidden = true
    }
  }

  private func updateBackgroundImageView(_ image: UIImage?) {
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
