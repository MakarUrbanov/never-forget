//
//  NotificationTimesTableView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 10.10.2023.
//

import UIKit

protocol INotificationTimesTableView: UITableView {}

class NotificationTimesTableView: UITableView, INotificationTimesTableView {

  private let viewModel: INotificationTimesTableViewModel

  // swiftlint:disable:next implicitly_unwrapped_optional
  private var diffableDataSource: DiffableDataSource!

  override var intrinsicContentSize: CGSize {
    layoutIfNeeded()
    return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
  }

  init(viewModel: INotificationTimesTableViewModel) {
    self.viewModel = viewModel
    super.init(frame: .zero, style: .plain)

    backgroundColor = .clear
    contentInsetAdjustmentBehavior = .never
    bounces = false
    separatorStyle = .none

    register(NotificationTimeCell.self, forCellReuseIdentifier: Self.Constants.timeCellId)
    register(AddNewNotificationTimeButton.self, forCellReuseIdentifier: Self.Constants.addNewTimeCell)

    let diffableDataSource = getDiffableDataSource()
    dataSource = diffableDataSource
    self.diffableDataSource = diffableDataSource
    delegate = self

    setupBindings()
    initializeDiffableDataSource()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupBindings() {
    viewModel.notificationsDates.bind { [weak self] newNotifications in
      self?.notificationsDidChange(newNotifications)
    }
  }

}

// MARK: - Diffable data source
extension NotificationTimesTableView {

  private func initializeDiffableDataSource() {
    var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()

    snapshot.appendSections([0])

    let items: [Item] = viewModel.notificationsDates.value.map { Item.timeCell($0) }
    snapshot.appendItems(items, toSection: 0)
    snapshot.appendItems([.addNewTimeButton], toSection: 0)

    diffableDataSource.apply(snapshot, animatingDifferences: false)
  }

  private func notificationsDidChange(_ newNotifications: [EventsNotification]) {
    var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()

    snapshot.appendSections([0])

    let items: [Item] = viewModel.notificationsDates.value.map { Item.timeCell($0) }
    snapshot.appendItems(items, toSection: 0)

    if items.count < Constants.timesCountToShowingAddNewOneButton {
      snapshot.appendItems([.addNewTimeButton], toSection: 0)
    }

    diffableDataSource.apply(snapshot, animatingDifferences: true)
  }

  private func configureTimeCell(with indexPath: IndexPath, for time: EventsNotification) -> UITableViewCell {
    guard let cell = dequeueReusableCell(
      withIdentifier: Constants.timeCellId, for: indexPath
    ) as? NotificationTimeCell else {
      fatalError("Dequeue error")
    }

    cell.setupCell(hour: time.hour?.intValue ?? 0, minute: time.minute?.intValue ?? 0)
    cell.deleteTime = { [weak self] in
      self?.viewModel.deleteTime(time)
    }

    return cell
  }

  private func configureAddNewTimeButton(with indexPath: IndexPath) -> UITableViewCell {
    guard let cell = dequeueReusableCell(
      withIdentifier: Constants.addNewTimeCell, for: indexPath
    ) as? AddNewNotificationTimeButton else {
      fatalError("Dequeue error")
    }

    cell.backgroundColor = UIColor(resource: .darkBackground)

    return cell
  }

  private func getDiffableDataSource() -> DiffableDataSource {
    let dataSource: DiffableDataSource = UITableViewDiffableDataSource(
      tableView: self,
      cellProvider: { _, indexPath, itemIdentifier in
        switch itemIdentifier {
          case .timeCell(let time):
            return self.configureTimeCell(with: indexPath, for: time)
          case .addNewTimeButton:
            return self.configureAddNewTimeButton(with: indexPath)
        }
      }
    )

    dataSource.defaultRowAnimation = .fade

    return dataSource
  }

}

// MARK: - UITableViewDelegate
extension NotificationTimesTableView: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = diffableDataSource.itemIdentifier(for: indexPath) else { return }

    if cell == .addNewTimeButton {
      viewModel.didPressAddNewTimeButton()
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let item = diffableDataSource.itemIdentifier(for: indexPath) else {
      return Constants.cellHeight
    }


    if item == .addNewTimeButton {
      return Constants.cellHeight
    }

    return Constants.cellHeight + Constants.spacingAmongFields
  }

}

// MARK: - Static
extension NotificationTimesTableView {

  enum Item: Hashable {
    case timeCell(EventsNotification)
    case addNewTimeButton
  }

  typealias DiffableDataSource = UITableViewDiffableDataSource<Int, Item>

  enum Constants {
    static let timeCellId = "timeCell"
    static let addNewTimeCell = "addNewTimeCell"
    static let timesCountToShowingAddNewOneButton = 5
    static let cellHeight: CGFloat = 44
    static let spacingAmongFields: CGFloat = 12
  }

}
