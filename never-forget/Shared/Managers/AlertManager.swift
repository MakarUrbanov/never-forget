//
//  AlertManager.swift
//  never-forget
//
//  Created by makar on 2/25/23.
//

import Foundation
import UIKit

class AlertManager {

  static let shared = AlertManager()

  weak var rootNavigationController: UINavigationController?

  private init() {}

  func show(with title: String, and message: String) {
    let alert = getAlert(title: title, message: message)
    rootNavigationController?.navigate(step: .present(alert, .automatic), animated: true)
  }

}

extension AlertManager {

  private func getAlert(title: String, message: String) -> UIAlertController {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "OK", style: .default)
    controller.addAction(alertAction)

    return controller
  }

}
