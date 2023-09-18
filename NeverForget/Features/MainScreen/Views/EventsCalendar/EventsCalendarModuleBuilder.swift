//
//  EventsCalendarModuleBuilder.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

import UIKit

enum EventsCalendarModuleBuilder {
  static func build(eventsService: IEventsCoreDataService) -> IEventsCalendarView {
    let interactor = EventsCalendarInteractor(eventsService: eventsService)
    let router = EventsCalendarRouter()
    let presenter = EventsCalendarPresenter(interactor: interactor, router: router)
    let viewController = EventsCalendarViewController()
    presenter.view = viewController
    viewController.presenter = presenter
    interactor.presenter = presenter
    router.viewController = viewController

    return viewController
  }
}
