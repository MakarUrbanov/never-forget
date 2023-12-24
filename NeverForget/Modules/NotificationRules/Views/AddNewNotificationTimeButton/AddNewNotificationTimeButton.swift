//
//  AddNewNotificationTimeButton.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 13.11.2023.
//

import NFCore
import SnapKit
import UIKit

class AddNewNotificationTimeButton: TouchableTableViewCell {

  private var dashedBorderLayer: CAShapeLayer?
  private lazy var addIcon = UIImageView(
    image: UIImage(systemName: "plus.circle.fill")?
      .withTintColor(UIColor(resource: .main100), renderingMode: .alwaysOriginal)
  )
  private lazy var titleLabel = UILabel()
  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [addIcon, titleLabel])
    stackView.spacing = 10
    stackView.axis = .horizontal
    stackView.alignment = .center

    return stackView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupUI()
  }


  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overrides

  override func layoutSubviews() {
    super.layoutSubviews()

    updateDashedBorderLayer()
  }

}

// MARK: - Setup UI
private extension AddNewNotificationTimeButton {

  private func setupUI() {
    setupStackView()
  }

  private func setupStackView() {
    addSubview(stackView)

    setupAddIcon()
    setupTitle()

    stackView.snp.makeConstraints { make in
      make.centerX.height.equalToSuperview()
    }
  }

  private func setupAddIcon() {
    addIcon.snp.makeConstraints { make in
      make.width.height.equalTo(24)
    }
  }

  private func setupTitle() {
    titleLabel.textColor = UIColor(resource: .main100)
    titleLabel.text = String(localized: "Add Notification")
  }

  private func updateDashedBorderLayer() {
    dashedBorderLayer?.removeFromSuperlayer()
    let dashSettings = DashedBorder(
      color: UIColor(resource: .main100), lineWidth: 1, cornerRadius: 8, dashPattern: [4, 2]
    )
    let newDashedBorderLayer = setAndGetDashedBorderLayer(settings: dashSettings)
    dashedBorderLayer = newDashedBorderLayer
  }

}

// MARK: - Static
extension AddNewNotificationTimeButton {

  enum Constants {
    static let topPadding = 12
  }

}

// MARK: - Preview
import SwiftUI

#Preview {
  let viewController = UIViewController()
  let addButton = AddNewNotificationTimeButton(frame: .zero)
  viewController.view.addSubview(addButton)

  addButton.snp.makeConstraints { make in
    make.width.equalTo(350)
    make.height.equalTo(44)
    make.center.equalToSuperview()
  }

  return viewController.makePreview()
}
