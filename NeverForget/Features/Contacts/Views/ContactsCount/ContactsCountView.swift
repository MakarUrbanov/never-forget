//
//  ContactsCountView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 19.09.2023.
//

import UIKit

protocol IContactsCountView: UIStackView {
  var contactsCount: Int { get }

  func setContactsCount(_ count: Int)
}

class ContactsCountView: UIStackView, IContactsCountView {

  let contactsTitleLabel = UILabel()
  let contactsCountLabel = UILabel()
  private(set) var contactsCount = 0

  init() {
    super.init(frame: .zero)

    axis = .horizontal
    distribution = .fill
    spacing = 8

    initialize()
  }

  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setContactsCount(_ count: Int) {
    contactsCount = count
    contactsCountLabel.text = String(count)
  }

}

// MARK: - Private methods
private extension ContactsCountView {

  private func initialize() {
    initializeContactsTitleLabel()
    initializeContactsCountLabel()
  }

  private func initializeContactsTitleLabel() {
    contactsTitleLabel.text = NSLocalizedString("Contacts", comment: "contacts count label")
    contactsTitleLabel.font = .systemFont(ofSize: 20, weight: .regular)
    contactsTitleLabel.textColor = UIColor(resource: .textLight100)

    addArrangedSubview(contactsTitleLabel)
  }

  private func initializeContactsCountLabel() {
    contactsCountLabel.text = "\(contactsCount)"
    contactsCountLabel.font = .systemFont(ofSize: 20, weight: .regular)
    contactsCountLabel.textColor = UIColor(resource: .textLight100).withAlphaComponent(0.3)

    addArrangedSubview(contactsCountLabel)
  }

}
