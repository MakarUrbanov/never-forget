//
//  ContactsScreenViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 18.09.2023
//

import UIKit

// MARK: - Protocol
protocol IContactsScreenView: UIViewController {
  func contactsChanged()
}

// MARK: - ViewController
class ContactsScreenViewController: UIViewController, IContactsScreenView {

  var presenter: IContactsScreenPresenter

  // MARK: - Private properties
  private let contactsCountView: IContactsCountView = ContactsCountView()
  private var sortingHeaderMenu: ISortHeaderMenu = SortHeaderMenu(selectedItem: .byNearestEvents)

  private let contactsTableView = UITableView(frame: .zero, style: .plain)
  private var diffableDataSource: UITableViewDiffableDataSource<Int, Contact>!

  init(presenter: IContactsScreenPresenter) {
    self.presenter = presenter

    super.init(nibName: nil, bundle: nil)

    diffableDataSource = getDiffableDataSource()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    initialize()

    presenter.viewDidLoad()
  }

  // MARK: - Public methods
  func contactsChanged() {
    let newContacts = presenter.getContacts()
    let contactsCount = presenter.getContactsCount()

    contactsCountView.setContactsCount(contactsCount)
    configureContactsSnapshot(with: newContacts, animated: true)
  }

}

// MARK: - Private methods
private extension ContactsScreenViewController {

  private func setSortingByNearestEvents() {
    presenter.setSortingByNearestEvents()
  }

  private func setSortingAlphabetically() {
    presenter.setSortingAlphabetically()
  }

  private func configureContactsSnapshot(with contacts: [Contact], animated: Bool = false) {
    var snapshot = diffableDataSource.snapshot()
    if snapshot.numberOfSections == 0 {
      snapshot.appendSections([0])
    }

    snapshot.appendItems(contacts)

    diffableDataSource.apply(snapshot, animatingDifferences: animated)
  }

  private func getDiffableDataSource() -> UITableViewDiffableDataSource<Int, Contact> {
    let dataSource: UITableViewDiffableDataSource<Int, Contact> = UITableViewDiffableDataSource(
      tableView: contactsTableView
    ) { tableView, indexPath, contact in
      guard
        let cell = tableView.dequeueReusableCell(
          withIdentifier: Self.contactCellIdentifier, for: indexPath
        ) as? ContactCellView else
      {
        fatalError()
      }

      let contact = self.presenter.getContact(at: indexPath)
      let isVisibleSeparator = !self.presenter.checkIsContactLastInTheList(contact)

      cell.configure(contact)
      cell.configureSeparatorVisibility(isVisibleSeparator)

      return cell
    }

    dataSource.defaultRowAnimation = .fade

    return dataSource
  }

}

// MARK: - Private UI methods
private extension ContactsScreenViewController {

  private func initialize() {
    initializeNavigationBar()
    initializeSortingHeaderMenu()
    initializeTableView()
  }

  private func initializeNavigationBar() {
    let leftBarButtonItem = UIBarButtonItem(customView: contactsCountView)
    navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)

    // TODO: mmk impl in the future
    //    let filterContactsButton = UIBarButtonItem(customView: FilterContactsButton())
    let addNewContactButton = UIBarButtonItem(customView: AddNewContactButton())
    navigationItem.setRightBarButtonItems([addNewContactButton], animated: false)
  }

  private func initializeSortingHeaderMenu() {
    sortingHeaderMenu.delegate = self

    view.addSubview(sortingHeaderMenu)

    sortingHeaderMenu.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.height.equalTo(50)
      make.horizontalEdges.equalToSuperview().inset(UIConstants.horizontalInset)
    }
  }

  private func initializeTableView() {
    contactsTableView.register(ContactCellView.self, forCellReuseIdentifier: Self.contactCellIdentifier)
    contactsTableView.backgroundColor = .clear
    contactsTableView.dataSource = diffableDataSource
//    contactsTableView.delegate = self
    contactsTableView.separatorColor = .clear
    contactsTableView.showsVerticalScrollIndicator = false

    view.addSubview(contactsTableView)

    contactsTableView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(UIConstants.horizontalInset)
      make.top.equalTo(sortingHeaderMenu.snp.bottom)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }

}

// MARK: - ISortHeaderMenuDelegate
extension ContactsScreenViewController: ISortHeaderMenuDelegate {

  func selectedItemDidChange(_ selectedItem: SortingMenuItem) {
    switch selectedItem {
      case .alphabetically:
        setSortingAlphabetically()
      case .byNearestEvents:
        setSortingByNearestEvents()
    }
  }

}

// MARK: - Static
extension ContactsScreenViewController {

  enum UIConstants {
    static let cellHeight: CGFloat = 85
    static let horizontalInset: CGFloat = 16
  }

  private static let contactCellIdentifier = String(describing: ContactCellView.self)

}
