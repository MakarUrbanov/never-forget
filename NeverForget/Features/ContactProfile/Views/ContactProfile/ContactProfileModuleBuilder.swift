//
//  ContactProfileModuleBuilder.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

import UIKit

enum ContactProfileModuleBuilder {

  static func buildEditContact(contact: Contact, coordinator: IContactProfileCoordinator) -> IContactProfileView {
    let interactor = ContactProfileInteractor(contact: contact)
    let router = ContactProfileRouter(coordinator: coordinator)
    let presenter = ContactProfilePresenter(interactor: interactor, router: router)
    let viewController = ContactProfileViewController(presenter: presenter, primaryButtonType: .save)

    presenter.view = viewController
    interactor.presenter = presenter
    router.viewController = viewController

    return viewController
  }

  static func buildCreateContact(contact: Contact, coordinator: IContactProfileCoordinator) -> IContactProfileView {
    let interactor = ContactProfileInteractor(contact: contact)
    let router = ContactProfileRouter(coordinator: coordinator)
    let presenter = ContactProfilePresenter(interactor: interactor, router: router)
    let viewController = ContactProfileViewController(presenter: presenter, primaryButtonType: .create)

    presenter.view = viewController
    interactor.presenter = presenter
    router.viewController = viewController

    return viewController
  }

}
