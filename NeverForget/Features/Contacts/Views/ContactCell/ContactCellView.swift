//
//  ContactCellView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 19.09.2023.
//

import SwiftDate
import UIKit

protocol IContactCellView: UITableViewCell {
  func configure(_ contact: Contact)
  func configureSeparatorVisibility(_ isVisible: Bool)
}

class ContactCellView: TouchableTableViewCell, IContactCellView {

  private let contactImageView = ContactImageView()
  private let contentStackView: UIStackView

  private let contactNameLabel = UILabel()
  private let eventCountdownLabel = UILabel()
  private let mainInfoStackView: UIStackView

  private let separator = UIView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    contentStackView = UIStackView(arrangedSubviews: [contactImageView])
    mainInfoStackView = UIStackView(arrangedSubviews: [contactNameLabel, eventCountdownLabel])

    super.init(style: style, reuseIdentifier: reuseIdentifier)

    initialize()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    resetView()
  }

  // MARK: - Public methods
  func configure(_ contact: Contact) {
    configureContactImage(contact)

    contactNameLabel.text = contact.generateFullName()

    let closestEvent = Self.findNearestEventForToday(of: contact)
    configureEventLabel(of: closestEvent)
  }

  func configureSeparatorVisibility(_ isVisible: Bool) {
    separator.isHidden = !isVisible
  }

}

// MARK: - Private methods
extension ContactCellView {

  private func configureContactImage(_ contact: Contact) {
    if let contactPhotoData = contact.photoData, let contactImage = UIImage(data: contactPhotoData) {
      contactImageView.setImage(contactImage)
    } else {
      let firstLetter = contact.firstName.first ?? String.Element("")
      contactImageView.setText(String(firstLetter))
    }
  }

  private func resetView() {
    contactImageView.resetView()
    contactNameLabel.text = ""
    eventCountdownLabel.text = ""
  }

  private func configureEventLabel(of event: Event) {
    if event.date.isToday == true {
      configureTodayEventLabel()
    } else {
      configureInFutureEventLabel(event)
    }
  }

  private func configureTodayEventLabel() {
    eventCountdownLabel.textColor = UIConstants.Colors.eventToday
    eventCountdownLabel.text = "Event today"
  }

  private func configureInFutureEventLabel(_ event: Event) {
    eventCountdownLabel.textColor = UIConstants.Colors.eventFuture

    let yearlyRoundedDate = Self.makeDateFutureByRoundingYear(date: event.date)
    let daysUntilEvent = Self.getDaysUntilFromToday(date: yearlyRoundedDate)
    eventCountdownLabel.text = "Event in \(daysUntilEvent) days"
  }

}

// MARK: - Initialize ui
extension ContactCellView {

  private func initialize() {
    configureContentStackView()
    initializeContactImageView()
    initializeMainInfoStackView()
    initializeSeparator()
  }

  private func configureContentStackView() {
    contentStackView.axis = .horizontal
    contentStackView.spacing = 0
    contentStackView.distribution = .fillProportionally
    contentStackView.alignment = .center

    contentView.addSubview(contentStackView)

    contentStackView.snp.makeConstraints { make in
      make.verticalEdges.equalToSuperview().inset(UIConstants.verticalInset)
      make.horizontalEdges.equalToSuperview()
    }
  }

  private func initializeContactImageView() {
    contentStackView.addArrangedSubview(contactImageView)

    contactImageView.snp.makeConstraints { make in
      make.width.greaterThanOrEqualTo(1)
      make.height.equalTo(contactImageView.snp.width)
    }
  }

  private func initializeMainInfoStackView() {
    mainInfoStackView.axis = .vertical
    mainInfoStackView.spacing = 4
    mainInfoStackView.distribution = .fill
    mainInfoStackView.alignment = .leading

    contentStackView.addArrangedSubview(mainInfoStackView)
    contentStackView.setCustomSpacing(24, after: contactImageView)

    mainInfoStackView.snp.makeConstraints { make in
      make.height.equalToSuperview()
      make.width.greaterThanOrEqualTo(3)
    }

    initializeContactNameLabel()
    initializeEventCountdownLabel()
  }

  private func initializeContactNameLabel() {
    contactNameLabel.font = .systemFont(ofSize: 15, weight: .regular)
    contactNameLabel.textColor = UIConstants.Colors.contactLabel
  }

  private func initializeEventCountdownLabel() {
    eventCountdownLabel.font = .systemFont(ofSize: 14, weight: .regular)
    eventCountdownLabel.textColor = UIConstants.Colors.eventFuture
  }

  private func initializeSeparator() {
    separator.backgroundColor = UIConstants.Colors.separatorColor
    contentView.addSubview(separator)

    separator.snp.makeConstraints { make in
      make.height.equalTo(1)
      make.bottom.leading.trailing.equalToSuperview()
    }
  }

}

// MARK: - Static
extension ContactCellView {

  private static let calendar = Calendar.current

  enum UIConstants {
    static let verticalInset = 20

    enum Colors {
      static let eventToday = UIColor(resource: .main100)
      static let eventFuture = UIColor(resource: .textLight100).withAlphaComponent(0.3)
      static let separatorColor = UIColor(resource: .textLight100).withAlphaComponent(0.03)
      static let contactLabel = UIColor(resource: .textLight100)
    }
  }

  private static func getDatePoints(of date: Date) -> Int {
    let monthMultiplier = 50
    return (date.month * monthMultiplier) + date.day
  }

  private static func findNearestEventForToday(of contact: Contact) -> Event {
    let events = contact.events

    if events.count == 1 {
      return events.first!
    }

    let todayPoints = Self.getDatePoints(of: .now)
    let eventsPoints: [(points: Int, event: Event)] = events
      .map { (points: Self.getDatePoints(of: $0.date), event: $0) }
      .sorted { $0.points < $1.points }

    if let nearestEventInThisYear = eventsPoints.first(where: { $0.points >= todayPoints }) {
      return nearestEventInThisYear.event
    }

    return eventsPoints[0].event
  }

  private static func makeDateFutureByRoundingYear(date: Date) -> Date {
    let isDateAlreadyFuture = date.isInFuture

    if isDateAlreadyFuture {
      return date
    }

    let dateComponents = calendar.dateComponents([.day, .month], from: date)
    return calendar.nextDate(
      after: date,
      matching: dateComponents,
      matchingPolicy: .nextTimePreservingSmallerComponents
    )!
  }

  private static func getDaysUntilFromToday(date: Date) -> Int64 {
    Date.now.getInterval(toDate: date, component: .day)
  }

}
