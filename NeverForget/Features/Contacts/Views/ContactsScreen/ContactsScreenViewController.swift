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
  let contactsTableView = UITableView(frame: .zero, style: .plain)

  init(presenter: IContactsScreenPresenter) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
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
    contactsTableView.reloadData()
  }

}

// MARK: - Private UI methods
private extension ContactsScreenViewController {

  private func initialize() {
    initializeNavigationBar()
    initializeTableView()
  }

  private func initializeNavigationBar() {
    let leftBarButtonItem = UIBarButtonItem(customView: ContactsCountView())
    navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)

    let filterContactsButton = UIBarButtonItem(customView: FilterContactsButton())
    let addNewContactButton = UIBarButtonItem(customView: AddNewContactButton())
    navigationItem.setRightBarButtonItems([addNewContactButton, filterContactsButton], animated: false)
  }

  private func initializeTableView() {
    contactsTableView.register(ContactCellView.self, forCellReuseIdentifier: Self.contactCellIdentifier)
    contactsTableView.backgroundColor = .clear
    contactsTableView.dataSource = self
    contactsTableView.delegate = self
    contactsTableView.separatorColor = .clear

    view.addSubview(contactsTableView)

    contactsTableView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(UIConstants.horizontalInset)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
    }
  }

}

// MARK: - UITableViewDataSource
extension ContactsScreenViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    UIConstants.cellHeight
  }

}

// MARK: - UITableViewDelegate
extension ContactsScreenViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    presenter.getContactsCount()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard
      let cell = tableView.dequeueReusableCell(
        withIdentifier: Self.contactCellIdentifier, for: indexPath
      ) as? ContactCellView else {
      fatalError()
    }

    let contact = presenter.getContact(at: indexPath)
    let isVisibleSeparator = !presenter.checkIsContactLastInTheList(contact)

    cell.configure(contact)
    cell.configureSeparatorVisibility(isVisibleSeparator)

    return cell
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
