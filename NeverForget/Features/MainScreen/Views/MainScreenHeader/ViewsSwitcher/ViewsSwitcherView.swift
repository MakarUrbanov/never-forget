//
//  ViewsSwitcherView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 07.09.2023.
//

import SnapKit
import UIKit

// MARK: - IViewsSwitcherView
protocol IViewsSwitcherView: UIView {
  var buttons: [SwitcherButtonData] { get }
  var currentSelectedButtonIndex: Int { get }
  var selectedButton: SwitcherButtonData { get }
  var delegate: IViewsSwitcherViewDelegate? { get set }
  var isAnimating: Bool { get }

  init(buttons: [SwitcherButtonData], initialButton: SwitcherButtonData?)

  func select(button: SwitcherButtonData, animated: Bool)
  /// 0-1 one item length
  func setSelectAnimated(_ position: CGFloat)
}

// MARK: - ViewsSwitcherView
class ViewsSwitcherView: UIView, IViewsSwitcherView {

  // MARK: - Public properties
  var buttons: [SwitcherButtonData]
  var currentSelectedButtonIndex: Int
  var selectedButton: SwitcherButtonData {
    buttons[currentSelectedButtonIndex]
  }

  var isAnimating = false

  weak var delegate: IViewsSwitcherViewDelegate?

  // MARK: - UI properties
  private let stackView = UIStackView()
  private let selector = UIView()

  // MARK: - Init
  required init(buttons: [SwitcherButtonData], initialButton: SwitcherButtonData? = nil) {
    self.buttons = buttons

    if let initialButton, let initialButtonIndex = buttons.firstIndex(of: initialButton) {
      currentSelectedButtonIndex = initialButtonIndex
    } else {
      currentSelectedButtonIndex = 0
    }
    super.init(frame: .zero)

    initialize()
  }

  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overrides
  override func layoutSubviews() {
    super.layoutSubviews()

    updateSelectorLayout(animated: false)
  }

  // MARK: - Public methods
  func select(button: SwitcherButtonData, animated: Bool) {
    selectButton(button, animated: animated)
  }

  func setSelectAnimated(_ position: CGFloat) {
    let pageWidth = bounds.width
    let itemWidth = pageWidth / CGFloat(buttons.count)
    let newOffset: CGFloat = position * itemWidth
    selector.frame = .init(
      x: newOffset,
      y: selector.frame.minY,
      width: selector.frame.width,
      height: selector.frame.height
    )
  }

}

// MARK: - Private methods
private extension ViewsSwitcherView {

  private func initialize() {
    layer.masksToBounds = true

    initializeStackView()
    initializeButtons()
    initializeSelector()
  }

  private func initializeStackView() {
    stackView.alignment = .center
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.layer.zPosition = 2
    stackView.spacing = 0

    addSubview(stackView)

    stackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func initializeButtons() {
    buttons.forEach { buttonData in
      let buttonView = getButton(buttonData)

      stackView.addArrangedSubview(buttonView)
    }
  }

  private func getButton(_ buttonData: SwitcherButtonData) -> UIButton {
    let buttonView = SwitcherButtonView(data: buttonData)
    buttonView.setTitle(buttonData.text, for: .normal)
    buttonView.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

    return buttonView
  }

  @objc
  private func buttonPressed(_ button: SwitcherButtonView) {
    guard isAnimating == false else { return }
    let buttonData = button.providedData

    guard (delegate?.viewsSwitcher(self, willSelect: buttonData) ?? true) == true else {
      return
    }

    if currentSelectedButtonIndex == buttonData.index {
      delegate?.viewsSwitcher(self, didSelectSelected: buttonData)
      return
    }

    selectButton(buttonData, animated: true)
  }

  private func selectButton(_ buttonData: SwitcherButtonData, animated: Bool) {
    delegate?.viewsSwitcher(self, didSelect: buttonData, previousSelectedButton: buttons[currentSelectedButtonIndex])

    let selectedButtonArrangedSubview = stackView.arrangedSubviews[buttonData.index]
    let center = selector.convert(selector.frame.origin, from: selectedButtonArrangedSubview)

    currentSelectedButtonIndex = buttonData.index
    if animated {
      isAnimating = true
      UIView.animate(withDuration: 0.3) { [self] in
        selector.frame = .init(
          origin: .init(x: center.x, y: 0),
          size: CGSize(width: selector.frame.width, height: selector.frame.height)
        )
      } completion: { [self] isComplete in
        if isComplete {
          isAnimating = false
        }
      }
    } else {
      selector.frame = .init(
        origin: .init(x: center.x, y: 0),
        size: CGSize(width: selector.frame.width, height: selector.frame.height)
      )
    }
  }

  private func initializeSelector() {
    selector.layer.zPosition = 1
    selector.backgroundColor = UIColor(resource: .main100)
    selector.isUserInteractionEnabled = false

    addSubview(selector)
  }

  private func updateSelectorLayout(animated: Bool) {
    let selectorWidth = bounds.width / CGFloat(buttons.count)
    selector.frame = .init(x: 0, y: 0, width: selectorWidth, height: bounds.height)
    selector.layer.cornerRadius = layer.cornerRadius
  }

}

// MARK: - SwitcherButtonView
extension ViewsSwitcherView {

  final class SwitcherButtonView: UIButton {
    var providedData: SwitcherButtonData

    init(data: SwitcherButtonData) {
      providedData = data
      super.init(frame: .zero)

      titleLabel?.font = .systemFont(.body, .regular)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }

}
