//
//  TitledMenuButton.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 29.09.2023.
//

import SnapKit
import UIKit

protocol ITitledMenuDelegate: AnyObject {
  func didSelect(identifier: TitledMenuButton.Identifier, with title: String)
}

protocol ITitledMenu: TitledView {
  var button: MenuButton { get }

  var delegate: ITitledMenuDelegate? { get set }
}

class TitledMenuButton: TitledView, ITitledMenu {

  let button = MenuButton()
  var menuConfiguration: Configuration
  var selectedItemIdentifier: Identifier?

  weak var delegate: ITitledMenuDelegate?

  required init(menuConfiguration: Configuration, initialMenuItem: MenuItem) {
    self.menuConfiguration = menuConfiguration

    super.init(children: button)

    button.menu = generateMenu()

    initializeInitialValue(initialMenuItem)
    setupUI()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

// MARK: - IMenuButtonDelegate
extension TitledMenuButton: IMenuButtonDelegate {

  func getButtonMenu() -> UIMenu {
    generateMenu()
  }

}


// MARK: - Private methods
private extension TitledMenuButton {

  private func initializeInitialValue(_ item: MenuItem) {
    button.setTitle(item.title, for: .normal)
    selectedItemIdentifier = item.identifier
  }

  private func generateMenu() -> UIMenu {
    let actions = generateActions()

    return UIMenu(
      title: menuConfiguration.title,
      subtitle: menuConfiguration.subtitle,
      image: menuConfiguration.image,
//      options: .singleSelection,
      preferredElementSize: menuConfiguration.preferredElementSize,
      children: actions
    )
  }

  private func generateActions() -> [UIAction] {
    menuConfiguration.elements.map({ action in
      let state: UIAction.State = action.identifier == self.selectedItemIdentifier ? .on : .off

      return UIAction(title: action.title, subtitle: action.subtitle, state: state) { [weak self] _ in
        guard let self else { return }

        self.selectedItemIdentifier = action.identifier
        self.button.setTitle(action.title, for: .normal)
        self.delegate?.didSelect(identifier: action.identifier, with: action.title)
      }
    })
  }

}

// MARK: - UI methods
private extension TitledMenuButton {

  private func setupUI() {
    setupButton()
  }

  private func setupButton() {
    button.delegate = self
  }

}

extension TitledMenuButton {

  typealias Identifier = Int

  struct MenuItem {
    var identifier: Identifier
    var title: String
    var subtitle: String?
  }

  struct Configuration {
    var title: String
    var subtitle: String?
    var image: UIImage?
    var preferredElementSize: UIMenu.ElementSize
    var elements: [MenuItem]
  }

}
