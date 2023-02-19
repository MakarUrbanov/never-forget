//
//  MainTabBarController.swift
//  never-forget
//
//  Created by makar on 2/6/23.
//

import SwiftUI
import UIKit

final class MainTabBarController: BaseTabBarController {
  func configure() {
    let mainTab = UIHostingController(rootView: MainTabView())
    mainTab.tabBarItem = UITabBarItem(title: Localizable.Tabs.main.toString(),
                                      image: UIImage(systemName: "house"),
                                      selectedImage: UIImage(systemName: "house"))

    let listTab = UIHostingController(rootView: ListTabView())
    listTab.tabBarItem = UITabBarItem(title: Localizable.Tabs.list.toString(),
                                      image: UIImage(systemName: "person"),
                                      selectedImage: UIImage(systemName: "person"))

    setViewControllers([mainTab, listTab], animated: false)

    selectedIndex = 1 // TODO: delete
  }
}

extension MainTabBarController {
  override func setViews() {
    super.setViews()
  }

  override func setConstraints() {
    super.setConstraints()
  }

  override func setAppearanceConfiguration() {
    super.setAppearanceConfiguration()
  }
}
