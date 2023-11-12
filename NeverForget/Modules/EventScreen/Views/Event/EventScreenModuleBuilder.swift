//
//  EventScreenModuleBuilder.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 29.09.2023
//

import UIKit

enum EventScreenModuleBuilder {

  static func build(event: Event) -> UIViewController {
    let interactor = EventScreenInteractor(event: event)
    let router = EventScreenRouter()
    let presenter = EventScreenPresenter(interactor: interactor, router: router)
    let viewController = EventScreenViewController(
      presenter: presenter,
      notificationsSchedulingRule: event.notificationScheduleRule
    )

    presenter.view = viewController
    interactor.presenter = presenter
    router.viewController = viewController

    return viewController
  }

}
