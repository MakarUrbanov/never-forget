//
//  ContactProfileViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

import IQKeyboardManagerSwift
import UIKit

protocol IContactProfileView: UIViewController {}

class ContactProfileViewController: UIViewController, IContactProfileView {

  // MARK: - Public properties
  var presenter: IContactProfilePresenter

  // MARK: - Ui
  private lazy var scrollView = UIScrollView()
  private lazy var contentContainerView = IQPreviousNextView()

  private lazy var photoPickerView = UIImageView() // TODO: mmk should be implemented
  private lazy var lastNameTextField = TitledTextField()
  private lazy var firstNameTextField = TitledTextField()
  private lazy var middleNameTextField = TitledTextField()
  private lazy var createContactButton = UIButton()

  // MARK: - Init
  init(presenter: IContactProfilePresenter) {
    self.presenter = presenter

    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = UIColor(resource: .darkBackground)

    initialize()
  }

}

// MARK: - Private methods
private extension ContactProfileViewController {

  @objc
  private func didPressCreateContactButton() {
    presenter.createContactDidPress()
  }

}

// MARK: - Setup UI methods
private extension ContactProfileViewController {

  private func initialize() {
    setupNavigationItem()

    setupCreateContactButton()
    setupScrollView()
    setupContentContainerView()

    setupPhotoPickerView()
    setupLastNameTextField()
    setupFirstNameTextField()
    setupMiddleNameTextField()
  }

  private func setupNavigationItem() {
    navigationItem.title = String(localized: "Adding a contact")

    let closeImage = UIImage(systemName: "xmark")?.withTintColor(UIColor(resource: .textLight100)
      .withAlphaComponent(0.3), renderingMode: .alwaysOriginal)
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: closeImage,
      primaryAction: UIAction(handler: { _ in
        self.presenter.closeProfile()
      })
    )
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

  private func setupScrollView() {
    scrollView.alwaysBounceVertical = true
    scrollView.showsVerticalScrollIndicator = false
    scrollView.keyboardDismissMode = .onDrag
    scrollView.isDirectionalLockEnabled = true

    view.addSubview(scrollView)

    scrollView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(UIConstants.verticalInset)
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.bottom.equalTo(createContactButton.snp.top).offset(-4)
    }
  }

  private func setupContentContainerView() {
    scrollView.addSubview(contentContainerView)

    contentContainerView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
      make.width.equalToSuperview()
    }
  }

  private func setupPhotoPickerView() {
    let size: CGFloat = 120
    photoPickerView.layer.cornerRadius = size / 2
    photoPickerView.layer.borderWidth = 1
    photoPickerView.layer.borderColor = UIColor(resource: .textLight100).withAlphaComponent(0.08).cgColor
    photoPickerView.contentMode = .center
    photoPickerView.image = UIImage(systemName: "camera")?.withTintColor(
      .init(resource: .textLight100),
      renderingMode: .alwaysOriginal
    )

    contentContainerView.addSubview(photoPickerView)

    photoPickerView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(24)
      make.centerX.equalToSuperview()
      make.height.width.equalTo(size)
    }

    let addPhotoImageView = UIImageView(
      image: UIImage(systemName: "plus")?
        .withTintColor(.white, renderingMode: .alwaysOriginal)
    )
    addPhotoImageView.backgroundColor = UIColor(resource: .main100)
    addPhotoImageView.layer.cornerRadius = 16
    addPhotoImageView.contentMode = .center

    photoPickerView.addSubview(addPhotoImageView)

    addPhotoImageView.snp.makeConstraints { make in
      make.top.trailing.equalToSuperview()
      make.width.height.equalTo(32)
    }
  }

  private func setupLastNameTextField() {
    lastNameTextField.setPlaceholder(String(localized: "Enter last name"))
    lastNameTextField.isRequiredField = true
    lastNameTextField.setTitle(String(localized: "Last name"))
    presenter.setupLastNameValidation(lastNameTextField)

    lastNameTextField.textField.didPressedKeyboardReturn = { [weak self] _ in
      self?.firstNameTextField.textField.becomeFirstResponder()
    }

    contentContainerView.addSubview(lastNameTextField)

    lastNameTextField.snp.makeConstraints { make in
      make.top.equalTo(photoPickerView.snp.bottom).offset(UIConstants.spacingAmongTextFields)
      make.horizontalEdges.equalToSuperview()
      make.width.equalToSuperview()
      make.height.equalTo(UIConstants.textFieldHeight)
    }
  }

  private func setupFirstNameTextField() {
    firstNameTextField.setPlaceholder(String(localized: "Enter name"))
    firstNameTextField.isRequiredField = true
    firstNameTextField.setTitle(String(localized: "Name"))
    presenter.setupFirstNameValidation(firstNameTextField)

    firstNameTextField.textField.didPressedKeyboardReturn = { [weak self] _ in
      self?.middleNameTextField.textField.becomeFirstResponder()
    }

    contentContainerView.addSubview(firstNameTextField)

    firstNameTextField.snp.makeConstraints { make in
      make.top.equalTo(lastNameTextField.snp.bottom).offset(UIConstants.spacingAmongTextFields)
      make.width.equalToSuperview()
      make.height.equalTo(UIConstants.textFieldHeight)
    }
  }

  private func setupMiddleNameTextField() {
    middleNameTextField.setPlaceholder(String(localized: "Enter middle name"))
    middleNameTextField.setTitle(String(localized: "Middle name"))

    middleNameTextField.textField.didPressedKeyboardReturn = { textField in
      textField.resignFirstResponder()
    }

    contentContainerView.addSubview(middleNameTextField)

    middleNameTextField.snp.makeConstraints { make in
      make.top.equalTo(firstNameTextField.snp.bottom).offset(UIConstants.spacingAmongTextFields)
      make.width.equalToSuperview()
      make.bottom.equalToSuperview().inset(40)
      make.height.equalTo(UIConstants.textFieldHeight)
    }
  }

}

// MARK: - Static
extension ContactProfileViewController {

  enum UIConstants {
    static let verticalInset: CGFloat = 16
    static let textFieldHeight: CGFloat = 72
    static let spacingAmongTextFields: CGFloat = 20
  }

  enum TextFieldTag: Int {
    case firstName = 0
    case secondName = 1
    case middleName = 2
  }

}
