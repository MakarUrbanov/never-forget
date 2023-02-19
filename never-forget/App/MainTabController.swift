//
//  MainTabController.swift
//  never-forget
//
//  Created by makar on 2/6/23.
//

import SwiftUI
import UIKit

final class MainTabController: BaseTabBarController {
  func configure() {
    let mainTab = UIHostingController(rootView: MainTabView())
    mainTab.tabBarItem = UITabBarItem(title: "Main",
                                      image: UIImage(systemName: "house"),
                                      selectedImage: UIImage(systemName: "house"))

    let listTab = UIHostingController(rootView: ListTabView())
    listTab.tabBarItem = UITabBarItem(title: "List",
                                      image: UIImage(systemName: "person"),
                                      selectedImage: UIImage(systemName: "person"))

    setViewControllers([mainTab, listTab], animated: false)

    selectedIndex = 1 // TODO: delete
  }
}

extension MainTabController {
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
