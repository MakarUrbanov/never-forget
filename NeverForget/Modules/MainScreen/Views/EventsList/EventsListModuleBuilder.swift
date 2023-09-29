//
//  EventsListModuleBuilder.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

import UIKit

enum EventsListModuleBuilder {

  static func build(eventsService: IEventsCoreDataService) -> IEventsListView {
    let interactor = EventsListInteractor(eventsService: eventsService)
    let router = EventsListRouter()
    let presenter = EventsListPresenter(interactor: interactor, router: router)
    let viewController = EventsListTableViewController(presenter: presenter)
    presenter.view = viewController
    interactor.presenter = presenter
    router.viewController = viewController

    return viewController
  }

}
