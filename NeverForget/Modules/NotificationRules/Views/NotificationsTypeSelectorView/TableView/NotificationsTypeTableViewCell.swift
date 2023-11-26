//
//  NotificationsTypeTableViewCell.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.11.2023.
//

import UIKit

class NotificationsTypeTableViewCell: TouchableTableViewCell {

  private lazy var titleLabel = UILabel()
  private lazy var checkmark = UIImageView(image: UIImage(resource: .heavyCheckmark))

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none

    setupUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setTitle(_ text: String) {
    titleLabel.text = text
  }

  func setIsChecked(_ isChecked: Bool) {
    titleLabel.textColor = isChecked ? UIColor(resource: .main100) : UIColor(resource: .textLight100)
    checkmark.isHidden = !isChecked
  }

}

// MARK: - Setup UI
extension NotificationsTypeTableViewCell {

  private func setupUI() {
    setupTitleLabel()
  }

  private func setupTitleLabel() {
    titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
    titleLabel.textColor = UIColor(resource: .textLight100)
    titleLabel.textAlignment = .left

    addSubview(titleLabel)

    titleLabel.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func setupCheckmark() {
    addSubview(checkmark)

    checkmark.snp.makeConstraints { make in
      make.trailing.top.bottom.equalToSuperview()
      make.width.equalTo(24)
    }
  }

}
