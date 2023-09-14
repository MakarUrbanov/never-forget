//
//  MainScreenModuleBuilder.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 14.09.2023
//

import UIKit

enum MainScreenModuleBuilder {
  static func build() -> IMainScreenView {
    let interactor = MainScreenInteractor()
    let router = MainScreenRouter()
    let presenter = MainScreenPresenter(interactor: interactor, router: router)
    let viewController = MainScreenViewController()
    presenter.view = viewController
    viewController.presenter = presenter
    interactor.presenter = presenter
    router.viewController = viewController

    return viewController
  }
}
