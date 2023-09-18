////
////  MainScreenViewController.swift
////  NeverForgetApp
////
////  Created by makar on 5/10/23.
////
//
// import CoreData
// import SnapKit
// import UIKit
//
//// MARK: - Protocol
// protocol MainScreenViewProtocol: AnyObject {
//  var coordinator: MainScreenCoordinator { get }
// }
//
//// MARK: - MainScreenViewController
// final class MainScreenViewController: UIViewController {
//
//  let viewModel: MainScreenViewModelProtocol
//
//  private var tableView = PersonsTableView()
//  private var diffableDataSource: PersonsTableView.PersonsDiffableDataSource
//
//  init(coordinator: MainScreenCoordinator) {
//    let fetchRequest = Person.sortedFetchRequest()
//    viewModel = MainScreenViewModel(context: CoreDataStack.shared.viewContext, fetchRequest: fetchRequest)
//    viewModel.coordinator = coordinator
//
//    diffableDataSource = tableView.makeDiffableDataSource()
//
//    super.init(nibName: nil, bundle: nil)
//  }
//
//  @available(*, unavailable)
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//
//  override func viewDidLoad() {
//    super.viewDidLoad()
//
//    initialize()
//  }
// }
//
//// MARK: - Private methods
// extension MainScreenViewController {
//
//  private func initialize() {
//    initializeTableView()
//    bindViewModel()
//    applySnapshotOfPersonsSection(viewModel.personsSectioned.value)
//  }
//
//  private func initializeTableView() {
//    tableView.backgroundColor = UIColor(resource: .background)
//
//    tableView.register(PersonsTableViewCell.self, forCellReuseIdentifier: PersonsTableViewCell.cellIdentifier)
//    tableView.register(
//      PersonsTableHeaderView.self,
//      forHeaderFooterViewReuseIdentifier: PersonsTableHeaderView.reuseIdentifier
//    )
//    tableView.dataSource = diffableDataSource
//    tableView.delegate = self
//
//    view.addSubview(tableView)
//
//    tableView.snp.makeConstraints { make in
//      make.edges.equalToSuperview()
//    }
//  }
//
//  private func bindViewModel() {
//    viewModel.personsSectioned.bind { newSection in
//      self.applySnapshotOfPersonsSection(newSection)
//    }
//  }
//
//  private func applySnapshotOfPersonsSection(_ personsSectioned: [TableViewPersonsSection]) {
//    var snapshot = diffableDataSource.makeSnapshot()
//    let sections: [PersonsTableSections] = personsSectioned.reduce([]) { partialResult, section in
//      partialResult + [section.section]
//    }
//    snapshot.appendSections(sections)
//
//    personsSectioned.forEach { section in
//      snapshot.appendItems(section.persons, toSection: section.section)
//    }
//
//
//    diffableDataSource.apply(snapshot, animatingDifferences: true)
//  }
//
//
// }
//
//// MARK: - UITableViewDelegate
// extension MainScreenViewController: UITableViewDelegate {
//
//  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    guard
//      let cell = tableView.cellForRow(at: indexPath) as? PersonsTableViewCell,
//      let personAdapter = cell.person else
//    {
//      return
//    }
//
//    viewModel.goToPersonProfile(person: personAdapter)
//  }
//
//  func tableView(
//    _ tableView: UITableView,
//    viewForHeaderInSection section: Int
//  ) -> UIView? {
//    guard let header = tableView
//      .dequeueReusableHeaderFooterView(
//        withIdentifier: PersonsTableHeaderView
//          .reuseIdentifier
//      ) as? PersonsTableHeaderView else
//    {
//      return nil
//    }
//
//    let section = diffableDataSource.snapshot().sectionIdentifiers[section]
//
//    header.setTitle(section.description)
//
//    return header
//  }
//
// }
