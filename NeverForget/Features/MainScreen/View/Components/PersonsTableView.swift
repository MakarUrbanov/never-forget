//
//  PersonsTableView.swift
//  NeverForgetApp
//
//  Created by makar on 5/21/23.
//

import CoreData
import UIKit

final class PersonsTableView: UITableView {

  init() {
    super.init(frame: .zero, style: .plain)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func makeDiffableDataSource() -> PersonsDiffableDataSource {
    PersonsDiffableDataSource(tableView: self)
  }

}

// MARK: - PersonsDiffableDataSource

extension PersonsTableView {

  final class PersonsDiffableDataSource: UITableViewDiffableDataSource<PersonsTableSections, PersonAdapter> {

    convenience init(tableView: UITableView) {
      self.init(tableView: tableView) { tableView, indexPath, person in
        guard let cell = tableView
          .dequeueReusableCell(
            withIdentifier: String(describing: PersonsTableViewCell.cellIdentifier),
            for: indexPath
          ) as? PersonsTableViewCell else
        {
          fatalError("Fail dequeueReusableCell")
        }

        cell.updateData(person: person)

        return cell
      }

      defaultRowAnimation = .none
    }

    func makeSnapshot() -> NSDiffableDataSourceSnapshot<PersonsTableSections, PersonAdapter> {
      NSDiffableDataSourceSnapshot<PersonsTableSections, PersonAdapter>()
    }

  }

}
