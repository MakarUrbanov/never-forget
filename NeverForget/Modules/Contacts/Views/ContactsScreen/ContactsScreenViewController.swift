//
//  ContactsScreenViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 18.09.2023
//

import UIKit

// MARK: - Protocol
protocol IContactsScreenView: UIViewController {
  func updateContactsList(_ contacts: [Contact])
  func openCreateNewProfileScreen()
}

// MARK: - ViewController
class ContactsScreenViewController: UIViewController, IContactsScreenView {

  // MARK: - Public properties
  private var presenter: IContactsScreenPresenter

  private lazy var sortingHeaderMenu: ISortHeaderMenu = SortHeaderMenu(selectedItem: .byNearestEvents)
  private lazy var contactsTableView = UITableView(frame: .zero, style: .plain)
  private lazy var contactsCountView: IContactsCountView = ContactsCountView()
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
  func updateContactsList(_ contacts: [Contact]) {
    let contactsCount = contacts.count
    contactsCountView.setContactsCount(contactsCount)
    applyContactsSnapshot(with: contacts, animated: true)
  }

  func openCreateNewProfileScreen() {
    presenter.presentCreateNewProfile()
  }

}

// MARK: - Private methods
private extension ContactsScreenViewController {

  private func applyContactsSnapshot(with contacts: [Contact], animated: Bool = false) {
    var snapshot = diffableDataSource.snapshot()
    if snapshot.numberOfSections == 0 {
      snapshot.appendSections([0])
    }

    snapshot.appendItems(contacts)
    updateContactsTableBackgroundView(contacts.count)

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

  private func updateContactsTableBackgroundView(_ itemsCount: Int) {
    if itemsCount == 0 {
      contactsTableView.backgroundView = Self.noContactsPlaceholderLabel
    } else {
      contactsTableView.backgroundView = nil
    }
  }

}

// MARK: - Private UI methods
private extension ContactsScreenViewController {

  private func initialize() {
    setupNavigationBar()
    setupSortingHeaderMenu()
    setupTableView()
  }

  private func setupNavigationBar() {
    let leftBarButtonItem = UIBarButtonItem(customView: contactsCountView)
    navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)

    // TODO: mmk impl in the future
    //    let filterContactsButton = UIBarButtonItem(customView: FilterContactsButton())
    let addNewContactButton = UIBarButtonItem(
      customView: AddNewContactButton(presentCreateNewProfile: { [weak self] in
        self?.presenter.presentCreateNewProfile()
      })
    )
    navigationItem.setRightBarButtonItems([addNewContactButton], animated: false)
  }

  private func setupSortingHeaderMenu() {
    sortingHeaderMenu.delegate = self

    view.addSubview(sortingHeaderMenu)

    sortingHeaderMenu.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.height.equalTo(50)
      make.horizontalEdges.equalToSuperview().inset(UIConstants.horizontalInset)
    }
  }

  private func setupTableView() {
    contactsTableView.register(ContactCellView.self, forCellReuseIdentifier: Self.contactCellIdentifier)
    contactsTableView.backgroundColor = .clear
    contactsTableView.dataSource = diffableDataSource
    contactsTableView.delegate = self
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

// MARK: - UITableViewDelegate
extension ContactsScreenViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    presenter.didSelectRowAt(indexPath: indexPath)
  }

}

// MARK: - ISortHeaderMenuDelegate
extension ContactsScreenViewController: ISortHeaderMenuDelegate {

  func selectedItemDidChange(_ selectedItem: SortingMenuItem) {
    presenter.sortingOptionDidChange(selectedItem)
  }

}

// MARK: - Static
extension ContactsScreenViewController {

  private static let contactCellIdentifier = String(describing: ContactCellView.self)

  private static var noContactsPlaceholderLabel: UILabel = {
    let label = UILabel()
    label.text = String(localized: "No contacts")
    label.textAlignment = .center
    label.textColor = UIColor(resource: .textLight100).withAlphaComponent(0.3)
    return label
  }()

  enum UIConstants {
    static let cellHeight: CGFloat = 85
    static let horizontalInset: CGFloat = 16
  }

}
