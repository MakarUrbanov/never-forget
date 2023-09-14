//
//  EventsCalendarModuleBuilder.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

import UIKit

enum EventsCalendarModuleBuilder {
  static func build() -> IEventsCalendarView {
    let interactor = EventsCalendarInteractor()
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
