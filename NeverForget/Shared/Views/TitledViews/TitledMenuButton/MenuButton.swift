//
//  MenuButton.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.10.2023.
//

import UIKit

// MARK: - Delegate
protocol IMenuButtonDelegate: AnyObject {
  func getButtonMenu() -> UIMenu
  func menuAttachmentPoint(_ menuButton: IMenuButton, for configuration: UIContextMenuConfiguration) -> CGPoint?
}

extension IMenuButtonDelegate {
  func menuAttachmentPoint(_ menuButton: IMenuButton, for configuration: UIContextMenuConfiguration) -> CGPoint? {
    nil
  }
}

// MARK: - IMenuButton
protocol IMenuButton: TouchableButton {
  var delegate: IMenuButtonDelegate? { get set }
}

// MARK: - MenuButton
class MenuButton: ButtonPlaceholder, IMenuButton {

  weak var delegate: IMenuButtonDelegate?
  private lazy var chevronDown = UIImageView(
    image: UIImage(systemName: "chevron.down")?
      .withTintColor(UIColor(resource: .textLight100), renderingMode: .alwaysOriginal)
  )

  required init() {
    super.init()

    isContextMenuInteractionEnabled = true
    showsMenuAsPrimaryAction = true

    setupUI()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func contextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    willDisplayMenuFor configuration: UIContextMenuConfiguration,
    animator: UIContextMenuInteractionAnimating?
  ) {
    askForMenu()

    super.contextMenuInteraction(interaction, willDisplayMenuFor: configuration, animator: animator)

    openChevron()
  }

  override func contextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    willEndFor configuration: UIContextMenuConfiguration,
    animator: UIContextMenuInteractionAnimating?
  ) {
    super.contextMenuInteraction(interaction, willEndFor: configuration, animator: animator)

    closeChevron()
  }

  override func menuAttachmentPoint(for configuration: UIContextMenuConfiguration) -> CGPoint {
    if let delegatedPoint = delegate?.menuAttachmentPoint(self, for: configuration) {
      return delegatedPoint
    }

    var point = super.menuAttachmentPoint(for: configuration)
    point.x = frame.minX

    return point
  }

  private func askForMenu() {
    if let menu = delegate?.getButtonMenu() {
      self.menu = menu
    }
  }

}

// MARK: - Setup UI
private extension MenuButton {

  private func setupUI() {
    setupChevron()
  }

  private func setupChevron() {
    addSubview(chevronDown)
    chevronDown.contentMode = .scaleAspectFit

    chevronDown.snp.makeConstraints { make in
      make.width.height.equalTo(17)
      make.trailing.equalToSuperview().offset(-16)
      make.centerY.equalToSuperview()
    }
  }

}

// MARK: - Private methods
private extension MenuButton {

  private func openChevron() {
    UIView.animate(withDuration: 0.15) {
      self.chevronDown.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
    }
  }

  private func closeChevron() {
    UIView.animate(withDuration: 0.15) {
      self.chevronDown.transform = CGAffineTransform(rotationAngle: 0)
    }
  }

}

// MARK: - Preview
import SwiftUI

#Preview {
  let viewController = UIViewController()
  let button = MenuButton()
  button.setTitle("Test", for: .normal)
  button.layer.borderWidth = 1
  button.layer.borderColor = UIColor(resource: .main100).cgColor

  viewController.view.addSubview(button)

  button.snp.makeConstraints { make in
    make.width.equalTo(350)
    make.height.equalTo(44)
    make.center.equalToSuperview()
  }

  return viewController.makePreview()
}
