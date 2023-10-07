//
//  EventScreenViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 29.09.2023
//

import UIKit

class EventScreenViewController: UIViewController {

  var presenter: IEventScreenPresenterInput

  private lazy var scrollView = UIScrollView()
  private lazy var contentView = UIView()

//  private lazy var originDatePicker = titled

  init(presenter: IEventScreenPresenterInput) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(resource: .darkBackground)

    setupUI()
  }

}

// MARK: - IEventScreenPresenterOutput
extension EventScreenViewController: IEventScreenPresenterOutput {
}

// MARK: - Setup UI
private extension EventScreenViewController {

  private func setupUI() {
    setupNavigationBar()
  }

  private func setupNavigationBar() {
    navigationItem.title = String(localized: "Adding an event")
    isModalInPresentation = true

    let arrowLeft = UIImage(systemName: "arrow.left")?.withTintColor(
      UIColor(resource: .textLight100).withAlphaComponent(0.3),
      renderingMode: .alwaysOriginal
    )
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      title: "",
      image: arrowLeft,
      primaryAction: UIAction(handler: { [weak self] _ in
        self?.presenter.goBack()
      })
    )
  }

}
