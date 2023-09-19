//
//  ContactCellView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 19.09.2023.
//

import UIKit

protocol IContactCellView: UITableViewCell {
  func configure(_ contact: Contact)
  func configureSeparatorVisibility(_ isVisible: Bool)
}

class ContactCellView: UITableViewCell, IContactCellView {

  private let contactImageView = ContactImageView()
  private let contentStackView: UIStackView

  private let contactNameLabel = UILabel()
  private let eventCountdownLabel = UILabel()
  private let mainInfoStackView: UIStackView

  private let separator = UIView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    self.contentStackView = UIStackView(arrangedSubviews: [contactImageView])
    self.mainInfoStackView = UIStackView(arrangedSubviews: [contactNameLabel, eventCountdownLabel])

    super.init(style: style, reuseIdentifier: reuseIdentifier)

    backgroundColor = .clear
    selectionStyle = .none

    initialize()
  }

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
    eventCountdownLabel.text = "Event start in 14 days" // TODO: mmk test
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
    contactNameLabel.textColor = UIColor(resource: .textLight100)
  }

  private func initializeEventCountdownLabel() {
    eventCountdownLabel.font = .systemFont(ofSize: 14, weight: .regular)
    eventCountdownLabel.textColor = UIColor(resource: .textLight100).withAlphaComponent(0.3)
  }

  private func initializeSeparator() {
    separator.backgroundColor = UIColor(resource: .textLight100).withAlphaComponent(0.03)
    contentView.addSubview(separator)

    separator.snp.makeConstraints { make in
      make.height.equalTo(1)
      make.bottom.leading.trailing.equalToSuperview()
    }
  }

}

// MARK: - Static
extension ContactCellView {

  enum UIConstants {
    static let verticalInset = 20
  }

}
