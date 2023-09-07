//
//  ViewsSwitcherView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 07.09.2023.
//

import SnapKit
import UIKit

// MARK: - Protocols
protocol IViewsSwitcherViewDelegate: AnyObject {
  func viewsSwitcher(_ switcher: IViewsSwitcherView, willSelect button: SwitcherButton) -> Bool
  func viewsSwitcher(_ switcher: IViewsSwitcherView, didSelect button: SwitcherButton)
  func viewsSwitcher(_ switcher: IViewsSwitcherView, didSelectSelected button: SwitcherButton)
}

extension IViewsSwitcherViewDelegate {
  func viewsSwitcher(_ switcher: IViewsSwitcherView, willSelect button: SwitcherButton) -> Bool {
    true
  }

  func viewsSwitcher(_ switcher: IViewsSwitcherView, didSelectSelected button: SwitcherButton) {}
}

protocol IViewsSwitcherView: UIView {
  var buttons: [SwitcherButton] { get }
  var selectedButton: SwitcherButton { get }
  var delegate: IViewsSwitcherViewDelegate? { get set }

  init(buttons: [SwitcherButton], initialButton: SwitcherButton?)
}

// MARK: - Models
struct SwitcherButton: Equatable {
  var text: String
  var index: Int
}

// MARK: - ViewsSwitcherView
class ViewsSwitcherView: UIView, IViewsSwitcherView {

  // MARK: - Public properties
  var buttons: [SwitcherButton]
  var selectedButton: SwitcherButton {
    buttons[currentSelectedButtonIndex]
  }

  weak var delegate: IViewsSwitcherViewDelegate?

  // MARK: - Private properties
  private var isAnimating = false
  private var currentSelectedButtonIndex: Int

  // MARK: - UI properties
  private let stackView = UIStackView()
  private let selector = UIView()

  // MARK: - Init
  required init(buttons: [SwitcherButton], initialButton: SwitcherButton? = nil) {
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

  override func layoutSubviews() {
    super.layoutSubviews()

    updateSelectorLayout(animated: false)
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

  private func getButton(_ buttonData: SwitcherButton) -> UIButton {
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

    delegate?.viewsSwitcher(self, didSelect: buttonData)

    let selectedButtonArrangedSubview = stackView.arrangedSubviews[buttonData.index]
    let center = selector.convert(selector.frame.origin, from: selectedButtonArrangedSubview)

    isAnimating = true
    currentSelectedButtonIndex = buttonData.index
    UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3) { [self] in
      selector.frame = .init(
        origin: .init(x: center.x, y: 0),
        size: CGSize(width: selector.frame.width, height: selector.frame.height)
      )
    } completion: { [self] isComplete in
      if isComplete {
        isAnimating = false
      }
    }
  }

  private func initializeSelector() {
    selector.layer.zPosition = 1
    selector.backgroundColor = UIColor.Theme.main100
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
    var providedData: SwitcherButton

    init(data: SwitcherButton) {
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
