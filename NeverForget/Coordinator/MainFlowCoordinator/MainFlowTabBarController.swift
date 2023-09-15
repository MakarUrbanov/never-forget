//
//  MainFlowTabBarController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 11.09.2023.
//

import SnapKit
import UIKit

class MainFlowTabBarController: UITabBarController {

  // MARK: - Private properties
  private let divider = UIView()

  // MARK: - Init
  init() {
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overrides
  override func viewDidLoad() {
    super.viewDidLoad()

    initialize()
  }

}

// MARK: - Private
private extension MainFlowTabBarController {

  private func initialize() {
    configureTabBar()
    initializeDivider()
  }

  private func configureTabBar() {
    view.backgroundColor = UIColor(resource: .darkBackground)

    let appearance = UITabBarAppearance()
    appearance.backgroundColor = UIColor(resource: .darkBackground)

    tabBar.standardAppearance = appearance
    tabBar.scrollEdgeAppearance = appearance

    tabBar.isTranslucent = false
    tabBar.tintColor = UIColor(resource: .main100)
    tabBar.unselectedItemTintColor = UIColor(resource: .secondary100)
  }

  private func initializeDivider() {
    divider.backgroundColor = UIColor(resource: .textLight4)

    tabBar.addSubview(divider)

    divider.snp.makeConstraints { make in
      make.leading.top.trailing.equalToSuperview()
      make.height.equalTo(1)
    }
  }

}
