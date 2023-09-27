//
//  ContactProfileViewController.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

import AVFoundation
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

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    presenter.viewDidDisappear()
  }

}

// MARK: - Private methods
private extension ContactProfileViewController {

  @objc
  private func didPressCreateContactButton() {
    presenter.createContactDidPress()
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
        let cameraImagePicker = CameraImagePicker()
        cameraImagePicker.delegate = self
        cameraImagePicker.cameraController.modalPresentationStyle = .overFullScreen
        self.present(cameraImagePicker.cameraController, animated: true)
      }
    }
  }

  private func openLibraryImagePicker() {
    let libraryImagePicker: IImagePicker = ImagePicker(
      configuration: ImagePicker.Configurations.OnePhotoConfiguration
    )

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
    presenter.deleteContactImage()
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
      primaryAction: UIAction(handler: { [weak self] _ in
        self?.presenter.closeProfile()
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
    presenter.setupMiddleNameValidation(middleNameTextField)

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

  enum PrimaryButtonType {
    case save
    case create
  }

}
