//
//  EventsListViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

import UIKit

protocol IEventsListView: UIViewController {
}

class EventsListViewController: UIViewController, IEventsListView {

  var presenter: IEventsListPresenter?

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .clear

    presenter?.viewDidLoad()

    initialize()
  }

}

// MARK: - Private methods
private extension EventsListViewController {

  private func initialize() {
  }

}
