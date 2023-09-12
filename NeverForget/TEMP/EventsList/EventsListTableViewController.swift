//
//  EventsListTableViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 11.09.2023.
//

import UIKit

// MARK: - Protocol
protocol IEventsListTableViewController: UITableViewController {
  var viewModel: IEventsListTableViewModel { get }

  init(viewModel: IEventsListTableViewModel)
}

// MARK: - EventsListTableViewController
class EventsListTableViewController: UITableViewController, IEventsListTableViewController {

  // MARK: - Public properties
  var viewModel: IEventsListTableViewModel

  // MARK: - Init
  required init(viewModel: IEventsListTableViewModel) {
    self.viewModel = viewModel
    super.init(style: .plain) // TODO: mmk check styles

    initialize()
    bindViewModel()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public methods
  override func viewDidLoad() {
    super.viewDidLoad()
  }

}

// MARK: - Private methods
private extension EventsListTableViewController {

  private func bindViewModel() {}

}

// MARK: - Private UI methods
private extension EventsListTableViewController {

  private func initialize() {
    view.backgroundColor = .clear
  }

}
