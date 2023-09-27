//
//  ContactProfileInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

import NFFormValidator
import UIKit

protocol IContactProfileInteractor: AnyObject {
  var contact: Contact { get }

  func setupLastNameValidation(_ textField: TitledTextField)
  func setupFirstNameValidation(_ textField: TitledTextField)
  func setupMiddleNameValidation(_ textField: TitledTextField)
  func validate() -> Bool
  func startValidating()
  func rollbackChanges()
  func saveChanges()

  func setContactImage(_ image: UIImage)
  func deleteContactImage()
}

class ContactProfileInteractor: IContactProfileInteractor {

  weak var presenter: IContactProfilePresenter?
  var contact: Contact

  private let formValidator = NFFormValidator()

  init(contact: Contact) {
    self.contact = contact
  }

  func validate() -> Bool {
    formValidator.validate()
  }

  func startValidating() {
    formValidator.startValidating()
  }

  func rollbackChanges() {
    contact.managedObjectContext?.rollback()
  }

  func saveChanges() {
    contact.managedObjectContext?.saveChanges()
  }

  func setContactImage(_ image: UIImage) {
    contact.setPhotoAndResize(image) {}
  }

  func deleteContactImage() {
    contact.clearPhotoData()
  }

}

// MARK: - Configure fields validation
extension ContactProfileInteractor {

  func setupLastNameValidation(_ textField: TitledTextField) {
    let field = NFObservableTextField(textField: textField.textField)
      .setupOnValid { [weak textField] in
        textField?.hideError()
      }
      .setupOnInvalid { [weak textField] error in
        guard let error else { return }

        textField?.setError(error)
      }
      .setupValidation { [weak self] lastName in
        guard let self, let lastName = lastName?.trim(), !lastName.isEmpty else {
          return (false, String(localized: "Required field"))
        }

        self.contact.lastName = lastName

        return (true, nil)
      }

    formValidator.addField(field)
  }

  func setupFirstNameValidation(_ textField: TitledTextField) {
    let field = NFObservableTextField(textField: textField.textField)
      .setupOnValid { [weak textField] in
        textField?.hideError()
      }
      .setupOnInvalid { [weak textField] error in
        guard let error else { return }

        textField?.setError(error)
      }
      .setupValidation { [weak self] firstName in
        guard let self, let firstName = firstName?.trim(), !firstName.isEmpty else {
          return (false, String(localized: "Required field"))
        }

        self.contact.firstName = firstName

        return (true, nil)
      }

    formValidator.addField(field)
  }

  func setupMiddleNameValidation(_ textField: TitledTextField) {
    let field = NFObservableTextField(textField: textField.textField)
      .setupOnValid { [weak textField] in
        textField?.hideError()
      }
      .setupOnInvalid { [weak textField] error in
        guard let error else { return }

        textField?.setError(error)
      }
      .setupValidation { [weak self] middleName in
        guard let self, let middleName = middleName?.trim() else {
          return (true, nil)
        }

        self.contact.middleName = middleName

        return (true, nil)
      }

    formValidator.addField(field)
  }

}
