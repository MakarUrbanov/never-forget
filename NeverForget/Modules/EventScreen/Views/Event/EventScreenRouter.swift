//
//  EventScreenRouter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 29.09.2023
//

import UIKit

protocol IEventScreenRouter: AnyObject {
  func goBack()
}

class EventScreenRouter: IEventScreenRouter {

  weak var viewController: UIViewController?

  func goBack() {
    viewController?.navigationController?.popViewController(animated: true)
  }

}
