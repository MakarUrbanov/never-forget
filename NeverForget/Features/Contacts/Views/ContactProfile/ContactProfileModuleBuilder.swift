//
//  ContactProfileModuleBuilder.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

import UIKit

enum ContactProfileModuleBuilder {

  static func build(contact: Contact, coordinator: IContactsListCoordinator) -> IContactProfileView {
    let interactor = ContactProfileInteractor(contact: contact)
    let router = ContactProfileRouter(coordinator: coordinator)
    let presenter = ContactProfilePresenter(interactor: interactor, router: router)
    let viewController = ContactProfileViewController(presenter: presenter)

    presenter.view = viewController
    interactor.presenter = presenter
    router.viewController = viewController

    return viewController
  }

}
