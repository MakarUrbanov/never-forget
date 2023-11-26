//
//  MainScreenHeaderView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.09.2023.
//

import UIKit

protocol IMainScreenHeaderView: UIStackView {
  var pageSwitcher: IViewsSwitcherView { get }
}

// MARK: - MainScreenHeaderView
class MainScreenHeaderView: UIStackView, IMainScreenHeaderView {

  let pickersStackView = UIStackView()
  let pageSwitcher: IViewsSwitcherView = ViewsSwitcherView(buttons: [
    .init(text: NSLocalizedString("Calendar", comment: "switcher item. view name"), index: 0),
    .init(text: NSLocalizedString("List", comment: "switcher item. view name"), index: 1),
  ])

  // TODO: mmk доделать
  let sortButton = UIButton(frame: .zero)
  let divider = UIView()

  // MARK: - Init
  init() {
    super.init(frame: .zero)

    axis = .vertical
    spacing = 0
    distribution = .fillProportionally

    initialize()
  }

  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

// MARK: - Private methods
private extension MainScreenHeaderView {

  private func initialize() {
    initializePickersStackView()
    initializePageHeaderDivider()
  }

  private func initializePickersStackView() {
    pickersStackView.axis = .horizontal
    pickersStackView.alignment = .fill
    pickersStackView.spacing = 8
    pickersStackView.distribution = .fillProportionally
    pickersStackView.layer.masksToBounds = true

    addArrangedSubview(pickersStackView)
    pickersStackView.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.greaterThanOrEqualTo(2)
    }

    initializePageSwitcher()
    initializeSortButton()
  }

  private func initializePageSwitcher() {
    pageSwitcher.layer.cornerRadius = 12
    pageSwitcher.backgroundColor = UIColor(resource: .textLight100).withAlphaComponent(0.08)

    pickersStackView.addArrangedSubview(pageSwitcher)
    pageSwitcher.snp.makeConstraints { make in
      make.height.equalToSuperview()
    }
  }

  private func initializeSortButton() {
    let imageSvg = UIImage(named: "filterIcon")
    sortButton.setImage(imageSvg, for: .normal)
    sortButton.contentMode = .scaleAspectFit
    sortButton.imageView?.tintColor = UIColor(resource: .textLight100)
    sortButton.backgroundColor = UIColor(resource: .textLight100).withAlphaComponent(0.08)
    sortButton.layer.cornerRadius = 12

    pickersStackView.addArrangedSubview(sortButton)
    sortButton.snp.makeConstraints { make in
      make.width.height.equalTo(40)
    }
  }

  private func initializePageHeaderDivider() {
    let dividerLine = UIView()
    dividerLine.backgroundColor = UIColor(resource: .textLight100).withAlphaComponent(0.04)
    divider.addSubview(dividerLine)
    dividerLine.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(1)
      make.centerX.equalToSuperview()
      make.centerY.equalTo(divider.snp.bottom).offset(-1)
    }

    addArrangedSubview(divider)
    divider.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.greaterThanOrEqualTo(1)
    }
  }

}
