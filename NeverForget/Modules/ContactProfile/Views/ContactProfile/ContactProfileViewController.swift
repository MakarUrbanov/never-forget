//
//  ContactProfileViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

import AVFoundation
import IQKeyboardManagerSwift
import NFFormValidator
import UIKit

class ContactProfileViewController: UIViewController {

  // MARK: - Public properties
  private var presenter: IContactProfilePresenterInput

  // MARK: - Private properties
  private let primaryButtonType: PrimaryButtonType

  // MARK: - Ui
  private lazy var scrollView = UIScrollView()
  private lazy var contentContainerView = IQPreviousNextView()

  private lazy var usersImageView: IUsersPhotoView = UsersPhotoView()

  private let fieldsValidationConfigurator: ContactProfileTextFieldValidationConfigurator
  private lazy var fieldsStackView = UIStackView()
  private lazy var lastNameTextField: ITitledTextField = TitledTextField()
  private lazy var firstNameTextField: ITitledTextField = TitledTextField()
  private lazy var middleNameTextField: ITitledTextField = TitledTextField()
  private lazy var birthdayEventButton: ITitledButton = TitledButton()

  private lazy var createContactButton = UIButton()

  private lazy var cameraImagePicker = CameraImagePicker()
  private lazy var libraryImagePicker: IImagePicker = ImagePicker(
    configuration: ImagePicker.Configurations.OnePhotoConfiguration
  )

  // MARK: - Init
  init(presenter: IContactProfilePresenterInput, primaryButtonType: PrimaryButtonType) {
    self.presenter = presenter
    self.primaryButtonType = primaryButtonType
    fieldsValidationConfigurator = ContactProfileTextFieldValidationConfigurator(presenter: presenter)

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

    setupUI()
    presenter.viewDidLoad()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    presenter.viewDidDisappear()
  }

}

// MARK: - IContactProfilePresenterOutput
extension ContactProfileViewController: IContactProfilePresenterOutput {

  func setLastName(_ lastName: String) {
    lastNameTextField.textField.text = lastName
  }

  func setFirstName(_ firstName: String) {
    firstNameTextField.textField.text = firstName
  }

  func setMiddleName(_ middleName: String) {
    middleNameTextField.textField.text = middleName
  }

  func setContactImage(_ image: UIImage) {
    usersImageView.setImage(image)
  }

  func setDateOfBirth(_ date: Date) {
    let dateFormatted = Date().formatterForRegion(format: "MM.dd.yyyy").string(from: date)
    birthdayEventButton.setText(dateFormatted)
  }

  func deleteContactImage() {
    usersImageView.reset()
  }

}

// MARK: - Private methods
private extension ContactProfileViewController {

  @objc
  private func didPressCreateContactButton() {
    presenter.didPressSaveContact()
  }

  private func didPressBirthday() {
    presenter.goToBirthdayEventScreen()
  }

  private func setNewContactsPhoto(_ image: UIImage) {
    presenter.setContactImage(image)
    usersImageView.setImage(image)
  }

  private func showImagePickerActionSheet() {
    let actionSheet = UIAlertController(
      title: String(localized: "Select photo source"),
      message: nil,
      preferredStyle: .actionSheet
    )

    actionSheet.addAction(UIAlertAction(title: String(localized: "Camera"), style: .default, handler: { _ in
      self.openCameraImagePicker()
    }))

    actionSheet.addAction(UIAlertAction(title: String(localized: "Photo Library"), style: .default, handler: { _ in
      self.openLibraryImagePicker()
    }))

    actionSheet.addAction(UIAlertAction(title: String(localized: "Cancel"), style: .cancel, handler: nil))

    present(actionSheet, animated: true)
  }

  private func openCameraImagePicker() {
    Task(priority: .high) {
      guard await CameraImagePicker.requestAccess() else { return }

      DispatchQueue.main.async {
        let picker = self.cameraImagePicker
        picker.delegate = self
        picker.cameraController.modalPresentationStyle = .overFullScreen
        self.present(picker.cameraController, animated: true)
      }
    }
  }

  private func openLibraryImagePicker() {
    libraryImagePicker.delegate = self
    present(libraryImagePicker.pickerViewController, animated: true)
  }

}

// MARK: - CameraPicker UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ContactProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {

  func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
  ) {
    let editedImage = info[.editedImage] as? UIImage
    let originalImage = info[.originalImage] as? UIImage

    if let image = editedImage ?? originalImage {
      setNewContactsPhoto(image)
    }

    picker.dismiss(animated: true)
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true)
  }

}

// MARK: - IUsersPhotoViewDelegate
extension ContactProfileViewController: IUsersPhotoViewDelegate {

  func didPressDeleteImage() {
    presenter.didPressDeleteContactImage()
  }

  func didPressAddImage() {
    showImagePickerActionSheet()
  }

  func didPressOnBodyWith(image: UIImage?) {
    showImagePickerActionSheet()
  }

}

// MARK: - IImagePickerDelegate
extension ContactProfileViewController: IImagePickerDelegate {

  func didSelectImages(_ images: [UIImage]) {
    guard let image = images.first else { return }
    setNewContactsPhoto(image)
  }

}

// MARK: - Setup UI methods
private extension ContactProfileViewController {

  private func setupUI() {
    setupNavigationItem()

    setupCreateContactButton()
    setupScrollView()
    setupContentContainerView()

    setupUsersImageView()
    setupFieldsStackView()
  }

  private func setupNavigationItem() {
    navigationItem.title = String(localized: "Adding a contact")

    let closeImage = UIImage(systemName: "xmark")?.withTintColor(UIColor(resource: .textLight100)
      .withAlphaComponent(0.3), renderingMode: .alwaysOriginal)
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: closeImage,
      primaryAction: UIAction(handler: { [weak self] _ in
        self?.presenter.didPressCloseProfile()
      })
    )
  }

  private func setupCreateContactButton() {
    let buttonTitle = primaryButtonType == .create ? String(localized: "Create") : String(localized: "Save")
    createContactButton.setTitle(buttonTitle, for: .normal)
    createContactButton.makePrimaryButton()

    let createContactAction = UIAction { [weak self] _ in
      self?.didPressCreateContactButton()
    }
    createContactButton.addAction(createContactAction, for: .primaryActionTriggered)

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

  private func setupFieldsStackView() {
    fieldsStackView.axis = .vertical
    fieldsStackView.distribution = .fillEqually
    fieldsStackView.spacing = UIConstants.spacingAmongTextFields

    contentContainerView.addSubview(fieldsStackView)

    fieldsStackView.snp.makeConstraints { make in
      make.top.equalTo(usersImageView.snp.bottom).offset(UIConstants.spacingAmongTextFields)
      make.width.horizontalEdges.equalToSuperview()
      make.bottom.equalToSuperview().inset(40)
    }

    setupFirstNameTextField()
    setupLastNameTextField()
    setupMiddleNameTextField()
    setupBirthdayEventButton()
  }

  private func setupFirstNameTextField() {
    firstNameTextField.textField.font = .systemFont(ofSize: 14, weight: .regular)
    firstNameTextField.textField.textColor = UIColor(resource: .textLight100)
    firstNameTextField.setPlaceholder(String(localized: "Enter name"))
    firstNameTextField.isRequiredField = true
    firstNameTextField.setTitle(String(localized: "Name"))
    fieldsValidationConfigurator.configureFirstName(titledTextField: firstNameTextField)

    firstNameTextField.textField.didPressedKeyboardReturn = { [weak self] _ in
      self?.lastNameTextField.textField.becomeFirstResponder()
    }

    fieldsStackView.addArrangedSubview(firstNameTextField)

    firstNameTextField.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(UIConstants.textFieldHeight)
    }
  }

  private func setupLastNameTextField() {
    lastNameTextField.textField.font = .systemFont(ofSize: 14, weight: .regular)
    lastNameTextField.textField.textColor = UIColor(resource: .textLight100)
    lastNameTextField.setPlaceholder(String(localized: "Enter last name"))
    lastNameTextField.isRequiredField = true
    lastNameTextField.setTitle(String(localized: "Last name"))
    fieldsValidationConfigurator.configureLastName(titledTextField: lastNameTextField)

    lastNameTextField.textField.didPressedKeyboardReturn = { [weak self] _ in
      self?.middleNameTextField.textField.becomeFirstResponder()
    }

    fieldsStackView.addArrangedSubview(lastNameTextField)

    lastNameTextField.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(UIConstants.textFieldHeight)
    }
  }

  private func setupMiddleNameTextField() {
    middleNameTextField.textField.font = .systemFont(ofSize: 14, weight: .regular)
    middleNameTextField.textField.textColor = UIColor(resource: .textLight100)
    middleNameTextField.setPlaceholder(String(localized: "Enter middle name"))
    middleNameTextField.setTitle(String(localized: "Middle name"))
    fieldsValidationConfigurator.configureMiddleName(titledTextField: middleNameTextField)

    middleNameTextField.textField.didPressedKeyboardReturn = { textField in
      textField.resignFirstResponder()
    }

    fieldsStackView.addArrangedSubview(middleNameTextField)

    middleNameTextField.snp.makeConstraints { make in
      make.width.equalToSuperview()
      make.height.equalTo(UIConstants.textFieldHeight)
    }
  }

  private func setupBirthdayEventButton() {
    birthdayEventButton.button.configuration?.baseForegroundColor = UIColor(resource: .textLight100)
    birthdayEventButton.button.configuration?.titleTextAttributesTransformer = .init {
      $0.merging(.init([
        .font: UIFont.systemFont(ofSize: 14, weight: .regular),
      ]))
    }

    birthdayEventButton.isRequiredField = true
    birthdayEventButton.setTitle(String(localized: "Date of Birth"))

    let pressBirthdayButtonAction = UIAction { [weak self] _ in
      self?.didPressBirthday()
    }
    birthdayEventButton.children.addAction(pressBirthdayButtonAction, for: .primaryActionTriggered)

    fieldsStackView.addArrangedSubview(birthdayEventButton)

    birthdayEventButton.snp.makeConstraints { make in
      make.width.equalToSuperview()
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

  enum PrimaryButtonType {
    case save
    case create
  }

}
