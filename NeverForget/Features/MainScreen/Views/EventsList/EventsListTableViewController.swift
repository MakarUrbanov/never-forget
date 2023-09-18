//
//  EventsListTableViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 15.09.2023
//

import SnapKit
import UIKit

protocol IEventsListView: UIViewController {
  func didChangeEvents()
}

class EventsListTableViewController: UIViewController, IEventsListView {

  var presenter: IEventsListPresenter

  private let tableView = UITableView(frame: .zero, style: .plain)

  init(presenter: IEventsListPresenter) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .clear
    initialize()

    presenter.viewDidLoad()
  }

  func didChangeEvents() {
    tableView.reloadData()
  }

}

// MARK: - Data source
extension EventsListTableViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    presenter.getDatesCount()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: Self.cellIdentifier,
      for: indexPath
    ) as! IEventTableCell

    let date = presenter.getDate(at: indexPath)
    let events = presenter.getEvents(for: date)
    cell.configure(date: date, events: events)

    return cell
  }


}

// MARK: - Delegate
extension EventsListTableViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UIContants.cellHeight
  }

}


// MARK: - Private methods
private extension EventsListTableViewController {

  private func initialize() {
    initializeTableView()
  }

  private func initializeTableView() {
    tableView.register(
      EventTableViewCell.self,
      forCellReuseIdentifier: Self.cellIdentifier
    )

    tableView.separatorStyle = .none

    tableView.dataSource = self
    tableView.delegate = self
    tableView.showsVerticalScrollIndicator = false
    tableView.backgroundColor = .clear

    view.addSubview(tableView)

    tableView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview()
      make.horizontalEdges.equalToSuperview().inset(MainScreenViewController.UIConstants.pageHorizontalInset)
    }
  }

}

// MARK: - Static
extension EventsListTableViewController {

  private static let cellIdentifier = String(describing: EventTableViewCell.self)

  enum UIContants {
    static let cellHeight: CGFloat = 85
  }

}
