//
//  EventsListModuleBuilder.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

import UIKit

enum EventsListModuleBuilder {

  static func build() -> IEventsListView {
    let interactor = EventsListInteractor()
    let router = EventsListRouter()
    let presenter = EventsListPresenter(interactor: interactor, router: router)
    let viewController = EventsListViewController()
    presenter.view = viewController
    viewController.presenter = presenter
    interactor.presenter = presenter
    router.viewController = viewController

    return viewController
  }

}
