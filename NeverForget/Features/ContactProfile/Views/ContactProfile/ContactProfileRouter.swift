//
//  ContactProfileRouter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

protocol IContactProfileRouter: AnyObject {
  func closeProfile()
}

class ContactProfileRouter: IContactProfileRouter {

  weak var viewController: IContactProfileView?
  weak var coordinator: IContactProfileCoordinator?

  init(coordinator: IContactProfileCoordinator) {
    self.coordinator = coordinator
  }

  // MARK: - Public methods
  func closeProfile() {
    coordinator?.close()
  }

}
