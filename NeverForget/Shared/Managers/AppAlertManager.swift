//
//  AppAlertManager.swift
//  never-forget
//
//  Created by makar on 2/25/23.
//

import Foundation
import UIKit

class AppAlertManager {

  typealias AlertButtonOptions = (title: String, style: UIAlertAction.Style, handler: (UIAlertAction) -> Void)

  static let shared = AppAlertManager()

  weak var rootNavigationController: UINavigationController?

  private init() {}

  func show(
    title: String = "",
    message: String = "",
    buttonOptions: [AlertButtonOptions] = [AppAlertManager.defaultOkButtonOptions]
  ) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    setButtons(buttonOptions, alert: alert)
    presentAlert(alert)
  }

}

// MARK: - private

extension AppAlertManager {

  private func presentAlert(_ alert: UIAlertController) {
    rootNavigationController?.navigate(step: .present(alert, .automatic), animated: true)
  }

  private func setButtons(_ buttonsOptions: [AlertButtonOptions], alert: UIAlertController) {
    for buttonOptions in buttonsOptions {
      let action = UIAlertAction(title: buttonOptions.title, style: buttonOptions.style, handler: buttonOptions.handler)
      alert.addAction(action)
    }
  }

}

// MARK: - static

extension AppAlertManager {

  private static let defaultOkButtonOptions: AlertButtonOptions = (title: "OK", style: .default, handler: { _ in })

}
