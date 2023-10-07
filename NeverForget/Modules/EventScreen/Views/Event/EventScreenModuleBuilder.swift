//
//  EventScreenModuleBuilder.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 29.09.2023
//

import UIKit

enum EventScreenModuleBuilder {

  static func build() -> UIViewController {
    let interactor = EventScreenInteractor()
    let router = EventScreenRouter()
    let presenter = EventScreenPresenter(interactor: interactor, router: router)
    let viewController = EventScreenViewController(presenter: presenter)

    presenter.view = viewController
    interactor.presenter = presenter
    router.viewController = viewController

    return viewController
  }

}
