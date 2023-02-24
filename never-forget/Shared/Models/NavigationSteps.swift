//
//  NavigationSteps.swift
//  never-forget
//
//  Created by makar on 2/23/23.
//

import UIKit

enum NavigationSteps {
  case push(UIViewController)
  case pop

  case present(UIViewController, UIModalPresentationStyle)
  case dismiss
}
