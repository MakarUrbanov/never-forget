//
//  SortHeaderMenu.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 19.09.2023.
//

import UIKit

// MARK: - Delegate
protocol ISortHeaderMenuDelegate: AnyObject {
  func selectedItemDidChange(_ selectedItem: SortingMenuItem)
}

typealias OptionalCallback<T> = T?

// MARK: - Protocol
protocol ISortHeaderMenu: UIView {
  var selectedItem: SortingMenuItem { get }

  var delegate: ISortHeaderMenuDelegate? { get set }

  func setSelectedItem(_ item: SortingMenuItem)
}

// MARK: - SortHeaderMenu
class SortHeaderMenu: UIControl, ISortHeaderMenu {

  var selectedItem: SortingMenuItem

  weak var delegate: ISortHeaderMenuDelegate?

  private let titleLabel = UILabel()
  private let selectedItemLabel = UILabel()
  private let triangleImageView = UIImageView(
    image: UIImage(systemName: "triangle.fill")!
      .withTintColor(UIColor(resource: .textLight100), renderingMode: .alwaysOriginal)
  )
  private let contentStackView = UIStackView()

  // MARK: - Init
  init(selectedItem: SortingMenuItem) {
    self.selectedItem = selectedItem

    super.init(frame: .zero)

    isContextMenuInteractionEnabled = true
    showsMenuAsPrimaryAction = true

    setSelectedItem(selectedItem)

    initialize()
  }

  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overrides
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    setAnimatedAlpha(UIConstants.highlightedAlpha)
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    setAnimatedAlpha(1)
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    alpha = 1
  }

  override func contextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    configurationForMenuAtLocation location: CGPoint
  ) -> UIContextMenuConfiguration? {
    UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [weak self] _ in
      self?.getMenu()
    })
  }

  override func contextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    willDisplayMenuFor configuration: UIContextMenuConfiguration,
    animator: UIContextMenuInteractionAnimating?
  ) {
    super.contextMenuInteraction(interaction, willDisplayMenuFor: configuration, animator: animator)

    rotateTriangleUp()
  }

  override func contextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    willEndFor configuration: UIContextMenuConfiguration,
    animator: UIContextMenuInteractionAnimating?
  ) {
    super.contextMenuInteraction(interaction, willEndFor: configuration, animator: animator)

    rotateTriangleDown()
  }

  override func menuAttachmentPoint(for configuration: UIContextMenuConfiguration) -> CGPoint {
    var point = super.menuAttachmentPoint(for: configuration)
    point.x = selectedItemLabel.frame.minX

    return point
  }

  // MARK: - Public methods
  func setSelectedItem(_ item: SortingMenuItem) {
    selectedItem = item
    setSelectedItemText(item)
    delegate?.selectedItemDidChange(item)
  }

}

// MARK: - Private
private extension SortHeaderMenu {

  private func setSelectedItemText(_ selectedItem: SortingMenuItem, animated: Bool = true) {
    UIView.transition(with: selectedItemLabel, duration: animated ? 0.3 : 0, options: .transitionFlipFromTop) {
      switch selectedItem {
        case .alphabetically:
          self.selectedItemLabel.text = NSLocalizedString("Alphabetically", comment: "Sorting type")
        case .byNearestEvents:
          self.selectedItemLabel.text = NSLocalizedString("By nearest event", comment: "Sorting type")
      }
    }
  }

  private func getMenu() -> UIMenu {
    let alphabetically = UIAction(
      title: NSLocalizedString("Alphabetically", comment: "Sorting type"),
      state: selectedItem == .alphabetically ? .on : .off
    ) { _ in
      if self.selectedItem != .alphabetically {
        self.setSelectedItem(.alphabetically)
      }
    }

    let byNearestEvent = UIAction(
      title: NSLocalizedString("By nearest event", comment: "Sorting type"),
      state: selectedItem == .byNearestEvents ? .on : .off
    ) { _ in
      if self.selectedItem != .byNearestEvents {
        self.setSelectedItem(.byNearestEvents)
      }
    }

    let menu = UIMenu(
      options: .singleSelection,
      preferredElementSize: .large,
      children: [alphabetically, byNearestEvent]
    )

    return menu
  }

  private func rotateTriangleUp() {
    UIView.animate(withDuration: 0.15) {
      self.triangleImageView.transform = CGAffineTransform(rotationAngle: UIConstants.triangleRotateUp)
    }
  }

  private func rotateTriangleDown() {
    UIView.animate(withDuration: 0.15) {
      self.triangleImageView.transform = CGAffineTransform(rotationAngle: UIConstants.triangleRotateDown)
    }
  }

}

// MARK: - UI methods
private extension SortHeaderMenu {

  private func initialize() {
    setupContentStackView()
    setupTitleLabel()
    setupSelectedOptionLabel()
    setupTriangleImage()
  }

  private func setupContentStackView() {
    contentStackView.axis = .horizontal
    contentStackView.spacing = 8
    contentStackView.alignment = .fill
    contentStackView.distribution = .fill
    contentStackView.isUserInteractionEnabled = false

    addSubview(contentStackView)

    contentStackView.snp.makeConstraints { make in
      make.leading.top.bottom.equalToSuperview()
      make.trailing.equalTo(contentStackView.snp.trailing)
    }
  }

  private func setupTitleLabel() {
    titleLabel.font = .systemFont(ofSize: 14, weight: .regular)
    titleLabel.textColor = UIColor(resource: .textLight100).withAlphaComponent(0.3)
    titleLabel.text = NSLocalizedString("Sorting", comment: "Sorting by rule")
    titleLabel.numberOfLines = 1

    contentStackView.addArrangedSubview(titleLabel)
  }

  private func setupSelectedOptionLabel() {
    selectedItemLabel.font = .systemFont(ofSize: 14, weight: .regular)
    selectedItemLabel.textColor = UIColor(resource: .textLight100)
    selectedItemLabel.numberOfLines = 1

    contentStackView.addArrangedSubview(selectedItemLabel)
  }

  private func setupTriangleImage() {
    triangleImageView.contentMode = .scaleAspectFit
    triangleImageView.transform = CGAffineTransform(rotationAngle: UIConstants.triangleRotateDown)

    contentStackView.addArrangedSubview(triangleImageView)

    triangleImageView.snp.makeConstraints { make in
      make.width.height.equalTo(8)
    }
  }

}

// MARK: - Static
extension SortHeaderMenu {

  enum UIConstants {
    static let highlightedAlpha = AppUIConstants.highlightedAlpha
    static let triangleRotateDown = CGFloat.pi * 0.999999
    static let triangleRotateUp: CGFloat = 0
  }

}
