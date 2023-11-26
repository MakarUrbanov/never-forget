//
//  NotificationsTypesTableView.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.11.2023.
//

import UIKit

class NotificationsTypesTableView: UITableView {

  var didSelectType: ((Event.NotificationsSchedulingRule) -> Void)?
  var selectedType: Event.NotificationsSchedulingRule

  init(initialType: Event.NotificationsSchedulingRule) {
    selectedType = initialType

    super.init(frame: .zero, style: .plain)

    delegate = self
    dataSource = self
    register(NotificationsTypeTableViewCell.self, forCellReuseIdentifier: "cell")
    separatorColor = UIColor(resource: .textLight8)
    backgroundColor = .clear
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension NotificationsTypesTableView: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView
      .dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NotificationsTypeTableViewCell else {
      return .init()
    }

    let typeData = getTypeDataByIndex(indexPath.item)
    cell.setTitle(typeData.title)
    cell.setIsChecked(typeData.isChecked)

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UIConstants.rowHeight
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedType = getTypeDataByIndex(indexPath.item).type
    didSelectType?(selectedType)
    tableView.reloadData()
  }

}

// MARK: - Private methods
extension NotificationsTypesTableView {

  private struct TypeData {
    let type: Event.NotificationsSchedulingRule
    let title: String
    let isChecked: Bool
  }

  private func getTypeDataByIndex(_ index: Int) -> TypeData {
    switch index {
      case 0:
        return .init(
          type: .globalSettings,
          title: NotificationTextByType.get(.globalSettings),
          isChecked: selectedType == .globalSettings
        )
      case 1:
        return .init(
          type: .customSettings,
          title: NotificationTextByType.get(.customSettings),
          isChecked: selectedType == .customSettings
        )
      case 2:
        return .init(
          type: .disabled,
          title: NotificationTextByType.get(.disabled),
          isChecked: selectedType == .disabled
        )
      default:
        return .init(
          type: .disabled,
          title: NotificationTextByType.get(.disabled),
          isChecked: selectedType == .disabled
        )
    }
  }

}

// MARK: - Static
extension NotificationsTypesTableView {

  enum UIConstants {
    static let rowHeight: CGFloat = 44
  }

}
