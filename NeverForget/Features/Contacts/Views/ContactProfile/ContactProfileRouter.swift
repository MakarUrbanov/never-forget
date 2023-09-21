//
//  ContactProfileRouter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

protocol IContactProfileRouter: AnyObject {
}

class ContactProfileRouter: IContactProfileRouter {

  weak var viewController: IContactProfileView?
  weak var coordinator: IContactsListCoordinator?

  init(coordinator: IContactsListCoordinator) {
  }

}
