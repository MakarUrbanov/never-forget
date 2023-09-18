//
//  MainScreenContentModuleBuilder.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

import UIKit

enum MainScreenContentModuleBuilder {
  static func build(eventsService: IEventsCoreDataService) -> IMainScreenContentView {
    let interactor = MainScreenContentInteractor(eventsService: eventsService)
    let router = MainScreenContentRouter()
    let presenter = MainScreenContentPresenter(interactor: interactor, router: router)
    let viewController = MainScreenContentViewController(presenter: presenter, eventsService: eventsService)
    presenter.view = viewController
    interactor.presenter = presenter
    router.viewController = viewController

    return viewController
  }
}
