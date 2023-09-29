//
//  ContactProfileTextFieldValidationConfigurator.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 28.09.2023.
//

import NFFormValidator

class ContactProfileTextFieldValidationConfigurator {

  private weak var presenter: IContactProfilePresenterInput?

  init(presenter: IContactProfilePresenterInput) {
    self.presenter = presenter
  }

  func configureFirstName(titledTextField: TitledTextField) {
    let field = NFObservableTextField(textField: titledTextField.textField)
      .setupOnValid { [weak titledTextField] in
        titledTextField?.hideError()
      }
      .setupOnInvalid { [weak titledTextField] error in
        guard let error else { return }

        titledTextField?.setError(error)
      }
      .setupValidation { [weak self] firstName in
        guard let self, let firstName = firstName?.trim(), !firstName.isEmpty else {
          return .invalid(String(localized: "Required field"))
        }

        self.presenter?.didChangeFirstName(firstName)

        return .valid()
      }

    presenter?.addValidatorField(field)
  }

  func configureLastName(titledTextField: TitledTextField) {
    let field = NFObservableTextField(textField: titledTextField.textField)
      .setupOnValid { [weak titledTextField] in
        titledTextField?.hideError()
      }
      .setupOnInvalid { [weak titledTextField] error in
        guard let error else { return }

        titledTextField?.setError(error)
      }
      .setupValidation { [weak self] lastName in
        guard let self, let lastName = lastName?.trim(), !lastName.isEmpty else {
          return .invalid(String(localized: "Required field"))
        }

        self.presenter?.didChangeLastName(lastName)

        return .valid()
      }

    presenter?.addValidatorField(field)
  }

  func configureMiddleName(titledTextField: TitledTextField) {
    let field = NFObservableTextField(textField: titledTextField.textField)
      .setupOnValid { [weak titledTextField] in
        titledTextField?.hideError()
      }
      .setupOnInvalid { [weak titledTextField] error in
        guard let error else { return }

        titledTextField?.setError(error)
      }
      .setupValidation { [weak self] middleName in
        guard let self, let middleName = middleName?.trim() else {
          return .valid()
        }

        self.presenter?.didChangeMiddleName(middleName)

        return .valid()
      }

    presenter?.addValidatorField(field)
  }

}
