//
//  ContactsScreenModuleBuilder.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 18.09.2023
//

import UIKit

enum ContactsScreenModuleBuilder {

  static func build() -> IContactsScreenView {
    let interactor = ContactsScreenInteractor()
    let router = ContactsScreenRouter()
    let presenter = ContactsScreenPresenter(interactor: interactor, router: router)
    let viewController = ContactsScreenViewController(presenter: presenter)

    presenter.view = viewController
    interactor.presenter = presenter
    router.viewController = viewController

    return viewController
  }

}
