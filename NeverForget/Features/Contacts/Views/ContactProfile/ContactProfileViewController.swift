//
//  ContactProfileViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

import UIKit

protocol IContactProfileView: UIViewController {
}

class ContactProfileViewController: UIViewController, IContactProfileView {

  // MARK: - Public properties
  var presenter: IContactProfilePresenter

  // MARK: - Ui
  private let contentScrollView = UIScrollView()
  private let createContactButton = UIButton()

  // MARK: - Init
  init(presenter: IContactProfilePresenter) {
    self.presenter = presenter
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    initialize()

    presenter.viewDidLoad()

    view.backgroundColor = UIColor(resource: .darkBackground)
  }

  @objc func handleSwipeDown() {
    view.endEditing(true)
  }
}

// MARK: - Setup UI methods
private extension ContactProfileViewController {

  private func initialize() {
    setupCreateContactButton()
    setupContentScrollView()
  }

  private func setupContentScrollView() {
    contentScrollView.alwaysBounceVertical = true
    contentScrollView.showsVerticalScrollIndicator = false

    view.addSubview(contentScrollView)

    contentScrollView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview()
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.bottom.equalTo(createContactButton.snp.top).offset(-4)
    }
  }

  private func setupCreateContactButton() {
    createContactButton.setTitle(String(localized: "Create"), for: .normal)
    createContactButton.setTitleColor(UIColor(resource: .textLight100), for: .normal)
    createContactButton.setTitleColor(UIColor(resource: .textLight100).withAlphaComponent(0.6), for: .highlighted)
    createContactButton.backgroundColor = UIColor(resource: .main100)
    createContactButton.layer.cornerRadius = 8
    createContactButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)

    createContactButton.addTarget(self, action: #selector(didPressCreateContactButton), for: .touchUpInside)

    view.addSubview(createContactButton)

    createContactButton.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      make.horizontalEdges.equalToSuperview().inset(UIConstants.verticalInset)
      make.height.equalTo(44)
    }
  }

}

// MARK: - Private methods
private extension ContactProfileViewController {

  @objc
  private func didPressCreateContactButton() {
  }

}

// MARK: - Static
extension ContactProfileViewController {

  enum UIConstants {
    static let verticalInset: CGFloat = 16
  }

}
