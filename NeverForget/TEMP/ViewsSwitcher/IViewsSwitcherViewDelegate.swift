//
//  IViewsSwitcherViewDelegate.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 08.09.2023.
//

import UIKit

// MARK: - IViewsSwitcherViewDelegate
protocol IViewsSwitcherViewDelegate: AnyObject {
  func viewsSwitcher(_ switcher: IViewsSwitcherView, willSelect button: SwitcherButtonData) -> Bool
  func viewsSwitcher(
    _ switcher: IViewsSwitcherView,
    didSelect button: SwitcherButtonData,
    previousSelectedButton: SwitcherButtonData
  )
  func viewsSwitcher(_ switcher: IViewsSwitcherView, didSelectSelected button: SwitcherButtonData)
}

// make optional
extension IViewsSwitcherViewDelegate {
  func viewsSwitcher(_ switcher: IViewsSwitcherView, willSelect button: SwitcherButtonData) -> Bool {
    true
  }

  func viewsSwitcher(_ switcher: IViewsSwitcherView, didSelectSelected button: SwitcherButtonData) {}
}
