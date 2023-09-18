//
//  ContactsScreenViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 18.09.2023
//

import UIKit

protocol IContactsScreenView: UIViewController {}

class ContactsScreenViewController: UIViewController, IContactsScreenView {

  var presenter: IContactsScreenPresenter

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

}

// MARK: - Private UI methods
private extension ContactsScreenViewController {

  private func initialize() {
    initializeNavigationBar()
  }

  private func initializeNavigationBar() {
    let leftBarButtonItem = UIBarButtonItem(customView: ContactsCountView())
    navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
  }

}
