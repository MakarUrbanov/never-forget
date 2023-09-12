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

    initialize()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

// MARK: - Private
private extension MainFlowTabBarController {

  private func initialize() {
    tabBar.tintColor = UIColor(resource: .main100)
    tabBar.unselectedItemTintColor = UIColor(resource: .secondary100)
    tabBar.backgroundColor = UIColor(resource: .darkBackground)
    tabBar.isTranslucent = false

    initializeDivider()
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
