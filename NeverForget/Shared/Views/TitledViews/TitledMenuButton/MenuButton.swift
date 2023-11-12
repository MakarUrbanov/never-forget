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

  required init() {
    super.init()

    isContextMenuInteractionEnabled = true
    showsMenuAsPrimaryAction = true
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willDisplayMenuFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
    askForMenu()
    super.contextMenuInteraction(interaction, willDisplayMenuFor: configuration, animator: animator)
  }

  override func menuAttachmentPoint(for configuration: UIContextMenuConfiguration) -> CGPoint {
    if let delegatedPoint = delegate?.menuAttachmentPoint(self, for: configuration) {
      return delegatedPoint
    }

    var point = super.menuAttachmentPoint(for: configuration)
    point.x = self.frame.minX

    return point
  }

  private func askForMenu() {
    if let menu = delegate?.getButtonMenu() {
      self.menu = menu
    }
  }

}
