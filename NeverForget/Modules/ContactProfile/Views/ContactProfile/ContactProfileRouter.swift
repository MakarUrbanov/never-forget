//
//  ContactProfileRouter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

import UIKit

protocol IContactProfileRouter: AnyObject {
  func closeProfile()
  func goToEventScreen(event: Event)
}

class ContactProfileRouter: IContactProfileRouter {

  weak var viewController: UIViewController?
  weak var coordinator: IContactProfileCoordinator?

  init(coordinator: IContactProfileCoordinator) {
    self.coordinator = coordinator
  }

  // MARK: - Public methods
  func closeProfile() {
    coordinator?.close()
  }

  func goToEventScreen(event: Event) {
    coordinator?.goToEventScreen(of: event)
  }

}
