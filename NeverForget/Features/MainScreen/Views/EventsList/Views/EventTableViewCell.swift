//
//  EventTableViewCell.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023.
//

import SwiftDate
import UIKit

// MARK: - Protocol
protocol IEventTableCell: UITableViewCell {
  var date: Date { get }
  var events: [Event] { get }

  func configure(date: Date, events: [Event])
}

// MARK: - EventTableViewCell
class EventTableViewCell: UITableViewCell, IEventTableCell {

  // MARK: - Public properties
  var date: Date = .now
  var events: [Event] = []

  // MARK: - Private properties
  private let dateLabel = UILabel()
  private let eventsDescriptionLabel = UILabel()
  private let stackView = UIStackView()
  private let ownersPhotos: IEventsOwnersPhotosView = PhotosOfEventsOwnersCollectionView()
  private let separator = UIView()

  // MARK: - Init
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .clear
    selectionStyle = .none

    initialize()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overrides
  override func prepareForReuse() {
    super.prepareForReuse()
    resetCell()
  }

  override func setHighlighted(_ highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: animated)
    setAlpha(by: highlighted)
  }

  // MARK: - Public methods
  func configure(date: Date, events: [Event]) {
    self.date = date
    self.events = events

    didUpdateDateLabel()
    didUpdateEventsDescriptionLabel()
    didUpdateOwnersPhotos()
  }

}

// MARK: - Private methods
private extension EventTableViewCell {

  private func didUpdateDateLabel() {
    let text = Self.getFormattedDate(date)
    dateLabel.text = text
  }

  private func didUpdateEventsDescriptionLabel() {
    let hasEvents = !events.isEmpty
    let color = hasEvents ? UIColor(resource: .main100) : UIColor(resource: .textLight100).withAlphaComponent(0.3)
    eventsDescriptionLabel.textColor = color

    eventsDescriptionLabel.text = Self.getDescription(by: events)
  }

  private func didUpdateOwnersPhotos() {
    ownersPhotos.setPhotos(for: events)
  }

  private func resetCell() {
    ownersPhotos.clearPhotos()
    alpha = 1
    dateLabel.text = ""
    eventsDescriptionLabel.text = ""
  }

  private func setAlpha(by highlighted: Bool) {
    UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction) {
      self.alpha = highlighted ? UIConstants.highlightedAlpha : 1
    }
  }

}

// MARK: - Initialize UI
private extension EventTableViewCell {

  private func initialize() {
    initializeStackView()
    initializeOwnersPhotos()
    initializeSeparator()
  }

  private func initializeStackView() {
    stackView.axis = .vertical
    stackView.spacing = 0
    stackView.distribution = .fillEqually
    stackView.alignment = .leading

    contentView.addSubview(stackView)

    stackView.snp.makeConstraints { make in
      make.leading.equalToSuperview()
      make.verticalEdges.equalToSuperview().inset(UIConstants.verticalInset)
      make.width.greaterThanOrEqualTo(stackView.snp.width)
    }

    initializeDateLabel()
    initializeDescriptionLabel()
  }

  private func initializeDateLabel() {
    dateLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
    dateLabel.textColor = UIColor(resource: .textLight100)
    dateLabel.textAlignment = .left

    stackView.addArrangedSubview(dateLabel)
  }

  private func initializeDescriptionLabel() {
    eventsDescriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    eventsDescriptionLabel.textAlignment = .left

    stackView.addArrangedSubview(eventsDescriptionLabel)
  }

  private func initializeOwnersPhotos() {
    contentView.addSubview(ownersPhotos)

    ownersPhotos.snp.makeConstraints { make in
      make.trailing.equalToSuperview()
      make.verticalEdges.equalToSuperview().inset(UIConstants.verticalInset)
      make.width.equalTo(self.snp.width).dividedBy(2)
//      make.width.greaterThanOrEqualTo(ownersPhotos.snp.width)
//      make.width.lessThanOrEqualTo(self.snp.width).dividedBy(2)
    }
  }

  private func initializeSeparator() {
    separator.backgroundColor = UIColor(resource: .textLight100).withAlphaComponent(0.04)
    contentView.addSubview(separator)
    separator.snp.makeConstraints { make in
      make.bottom.leading.trailing.equalToSuperview()
      make.height.equalTo(1)
    }
  }

}

// MARK: - Static
extension EventTableViewCell {

  enum UIConstants {
    static let verticalInset = 20
    static let highlightedAlpha: CGFloat = 0.8
  }

  private static let DATE_FORMAT = "dd MMMM"

  private static func getFormattedDate(_ date: Date) -> String {
    switch true {
      case date.isToday:
        let prefix = String(localized: "Today")
        let formattedDate = date.toFormat(DATE_FORMAT)
        return "\(prefix), \(formattedDate)"

      case date.isTomorrow:
        let prefix = String(localized: "Tomorrow")
        let formattedDate = date.toFormat(DATE_FORMAT)
        return "\(prefix), \(formattedDate)"

      default:
        return date.toFormat(DATE_FORMAT)
    }
  }

  private static func formatContactName(_ contact: Contact) -> String {
    let lastName = contact.lastName ?? ""
    let hasLastName = !lastName.isEmpty

    if hasLastName {
      let firstNameFirstLetter = contact.firstName.first ?? String.Element("")

      return "\(lastName) \(firstNameFirstLetter)."
    }

    return contact.firstName
  }

  private static func getDescription(by events: [Event]) -> String {
    let eventsCount = events.count

    switch eventsCount {
      case 1:
        let event = events.first!
        let eventOwner = event.owner!

        return formatContactName(eventOwner)

      case 2...:
        return "\(eventsCount) events"

      default:
        return "No events"
    }
  }

}
