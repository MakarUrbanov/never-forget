//
//  PersonsTableViewCell.swift
//  NeverForgetApp
//
//  Created by makar on 5/11/23.
//

import SwiftUI
import UIKit

class PersonsTableViewCell: UITableViewCell {

  static let cellIdentifier = String(describing: PersonsTableViewCell.self)

  var person: PersonAdapter?
  var imageData: Data? { didSet { userImageView.loadImageFromData(imageData) } }
  var username: String? { didSet { usernameLabel.text = username } }
  var dateOfBirth: Date? {
    didSet {
      guard let dateOfBirth else { return }

      let dateFormatted = DateFormatter(dateFormat: "d MMMM")
      let formattedDate = dateFormatted.string(from: dateOfBirth)

      dateOfBirthLabel.text = formattedDate
    }
  }

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setViews()
    setConstraints()
    setAppearanceConfiguration()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private let containerStackView: UIStackView = {
    let view = UIStackView()
    view.isLayoutMarginsRelativeArrangement = true
    view.directionalLayoutMargins = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
    view.spacing = 20
    view.alignment = .center
    view.distribution = .fill
    return view
  }()

  private let userImageView: UserImageView = {
    let image = UserImageView()
    image.placeholderImage.tintColor = UIColor(resource: .text2)
    image.layer.cornerRadius = 20
    return image
  }()

  private let textStack: UIStackView = {
    let view = UIStackView()
    view.axis = .vertical
    view.spacing = -4
    view.alignment = .leading
    view.distribution = .fillEqually
    return view
  }()

  private let usernameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.numberOfLines = 1
    label.textColor = UIColor(resource: .text)
    label.font = .systemFont(.title3, .bold)
    return label
  }()

  private let dateOfBirthLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .left
    label.numberOfLines = 1
    label.textColor = UIColor(resource: .text3)
    label.font = .systemFont(.subheadline, .medium)
    return label
  }()

  func updateData(person: PersonAdapter) {
    self.person = person
    imageData = person.photo
    username = person.name
    dateOfBirth = person.dateOfBirth
  }

}

extension PersonsTableViewCell {

  private func setViews() {
    textStack.addArrangedSubview(usernameLabel)
    textStack.addArrangedSubview(dateOfBirthLabel)

    containerStackView.addArrangedSubview(userImageView)
    containerStackView.addArrangedSubview(textStack)

    addView(containerStackView)
  }

  private func setConstraints() {
    NSLayoutConstraint.activate([
      userImageView.heightAnchor.constraint(equalToConstant: 40),
      userImageView.widthAnchor.constraint(equalToConstant: 40),

      containerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
      containerStackView.topAnchor.constraint(equalTo: topAnchor),
      containerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
      containerStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }

  private func setAppearanceConfiguration() {
    containerStackView.backgroundColor = UIColor(resource: .background)
    selectionStyle = .none
  }

}
