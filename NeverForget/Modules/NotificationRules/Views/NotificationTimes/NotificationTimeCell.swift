//
//  NotificationTimeCell.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 13.11.2023.
//

import UIKit

class NotificationTimeCell: UITableViewCell {

  var deleteTime: (() -> Void)?

  private lazy var footerView = UIView()
  private lazy var contentStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [notificationTypePicker, timeLabel, deleteButton])
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.spacing = 0

    stackView.backgroundColor = UIColor(resource: .darkBackground)

    return stackView
  }()

  private lazy var notificationTypePicker: UIButton = {
    let button = UIButton()
    button.setTitle("Regular", for: .normal)

    return button
  }()

  private lazy var timeLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white

    return label
  }()

  private lazy var deleteButton: UIButton = {
    let button = UIButton()
    button.setTitle("Delete", for: .normal)
    button.backgroundColor = .red.withAlphaComponent(0.2)
    button.addAction(.init(handler: { [weak self] _ in
      self?.deleteTime?()
      print("mmk delete")
    }), for: .primaryActionTriggered)

    return button
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupUI()
    selectionStyle = .none
    backgroundColor = .clear
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupCell(hour: Int, minute: Int) {
    timeLabel.text = "\(hour) \(minute)"
  }

}

// MARK: - Setup UI
private extension NotificationTimeCell {

  private func setupUI() {
    layoutFooterView()
    layoutContentStackView()
  }

  private func layoutFooterView() {
    contentView.addSubview(footerView)

    footerView.snp.makeConstraints { make in
      make.left.bottom.right.equalToSuperview()
      make.height.equalTo(Constants.topPadding)
    }
  }

  private func layoutContentStackView() {
    contentView.addSubview(contentStackView)

    contentStackView.snp.makeConstraints { make in
      make.left.top.right.equalToSuperview()
      make.bottom.equalTo(footerView.snp.top)
    }

    layoutNotificationTypePicker()
    layoutTimeLabel()
    layoutDeleteButton()
  }

  private func layoutNotificationTypePicker() {
    notificationTypePicker.snp.makeConstraints { make in
      make.height.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.5)
    }
  }

  private func layoutTimeLabel() {
    timeLabel.snp.makeConstraints { make in
      make.height.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.3)
    }
  }

  private func layoutDeleteButton() {
    deleteButton.snp.makeConstraints { make in
      make.height.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.2)
    }
  }

}

// MARK: - Static
private extension NotificationTimeCell {

  enum Constants {
    static let topPadding = 12
  }

}
