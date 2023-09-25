//
//  ContactProfileViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

import IQKeyboardManagerSwift
import UIKit

protocol IContactProfileView: UIViewController {
  func setupInitialLastName(_ lastName: String)
  func setupInitialFirstName(_ firstName: String)
  func setupInitialMiddleName(_ middleName: String)
  func setupInitialUsersImage(_ image: UIImage)
}

class ContactProfileViewController: UIViewController, IContactProfileView {

  // MARK: - Public properties
  var presenter: IContactProfilePresenter

  // MARK: - Private properties
  private let primaryButtonType: PrimaryButtonType

  // MARK: - Ui
  private lazy var scrollView = UIScrollView()
  private lazy var contentContainerView = IQPreviousNextView()

  private lazy var usersImageView: IUsersPhotoView = UsersPhotoView()
  private lazy var lastNameTextField = TitledTextField()
  private lazy var firstNameTextField = TitledTextField()
  private lazy var middleNameTextField = TitledTextField()
  private lazy var createContactButton = UIButton()

  // MARK: - Init
  init(presenter: IContactProfilePresenter, primaryButtonType: PrimaryButtonType) {
    self.presenter = presenter
    self.primaryButtonType = primaryButtonType

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

    presenter.viewDidLoad()
  }

}

// MARK: - Private methods
private extension ContactProfileViewController {

  @objc
  private func didPressCreateContactButton() {
    presenter.createContactDidPress()
  }

}

// MARK: - Setup initial values
extension ContactProfileViewController {

  func setupInitialLastName(_ lastName: String) {
    lastNameTextField.textField.text = lastName
  }

  func setupInitialFirstName(_ firstName: String) {
    firstNameTextField.textField.text = firstName
  }

  func setupInitialMiddleName(_ middleName: String) {
    middleNameTextField.textField.text = middleName
  }

  func setupInitialUsersImage(_ image: UIImage) {
    usersImageView.setImage(image)
  }

}

// MARK: - IUsersPhotoViewDelegate
extension ContactProfileViewController: IUsersPhotoViewDelegate {

  func didPressDeleteImage() {
    usersImageView.reset()
  }

  func didPressAddImage() {
    // TODO: mmk picker
  }

  func didPressOnBodyWith(image: UIImage?) {
    // TODO: mmk picker
  }

}

// MARK: - Setup UI methods
private extension ContactProfileViewController {

  private func initialize() {
    setupNavigationItem()

    setupCreateContactButton()
    setupScrollView()
    setupContentContainerView()

    setupUsersImageView()
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

  private func setupUsersImageView() {
    usersImageView.delegate = self

    contentContainerView.addSubview(usersImageView)

    usersImageView.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(24)
      make.centerX.equalToSuperview()
      make.height.width.equalTo(120)
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
      make.top.equalTo(usersImageView.snp.bottom).offset(UIConstants.spacingAmongTextFields)
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

  enum PrimaryButtonType {
    case save
    case create
  }

}
