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
  var contactsCount = 0

  init() {
    super.init(frame: .zero)

    axis = .horizontal
    distribution = .fill
    spacing = 8

    initialize()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setContactsCount(_ count: Int) {
    contactsCount = count
  }

}

// MARK: - Private methods
private extension ContactsCountView {

  private func initialize() {
    initializeContactsTitleLabel()
    initializeContactsCountLabel()
  }

  private func initializeContactsTitleLabel() {
    contactsTitleLabel.text = String(localized: "Contacts")
    contactsTitleLabel.font = .systemFont(ofSize: 20, weight: .regular)
    contactsTitleLabel.textColor = UIColor(resource: .textLight100)

    addArrangedSubview(contactsTitleLabel)
  }

  private func initializeContactsCountLabel() {
    contactsCountLabel.text = "\(self.contactsCount)"
    contactsCountLabel.font = .systemFont(ofSize: 20, weight: .regular)
    contactsCountLabel.textColor = UIColor(resource: .textLight100).withAlphaComponent(0.3)

    addArrangedSubview(contactsCountLabel)
  }

}
