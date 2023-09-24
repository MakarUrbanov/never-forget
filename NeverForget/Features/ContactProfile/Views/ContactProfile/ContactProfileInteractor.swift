//
//  ContactProfileInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

import NFFormValidator
import UIKit

protocol IContactProfileInteractor: AnyObject {
  func setupLastNameValidation(_ textField: TitledTextField)
  func setupFirstNameValidation(_ textField: TitledTextField)
  func validate() -> Bool
  func startValidating()
}

class ContactProfileInteractor: IContactProfileInteractor {

  weak var presenter: IContactProfilePresenter?
  var contact: Contact

  private let formValidator = NFFormValidator()

  init(contact: Contact) {
    self.contact = contact
  }

  func startValidating() {
    formValidator.startValidating()
  }

  func validate() -> Bool {
    formValidator.validate()
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
