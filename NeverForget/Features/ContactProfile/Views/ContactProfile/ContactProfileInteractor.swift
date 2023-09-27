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
      .setupValidation { lastName in
        guard let lastName, !lastName.isEmpty else { return (false, String(localized: "Required field")) }

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
      .setupValidation { firstName in
        guard let firstName, !firstName.isEmpty else { return (false, String(localized: "Required field")) }

        return (true, nil)
      }

    formValidator.addField(field)
  }

}
