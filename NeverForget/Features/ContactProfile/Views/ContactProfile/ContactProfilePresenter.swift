//
//  ContactProfilePresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

protocol IContactProfilePresenter: AnyObject {
  func closeProfile()
  func createContactDidPress()
  func setupLastNameValidation(_ textField: TitledTextField)
  func setupFirstNameValidation(_ textField: TitledTextField)
}

class ContactProfilePresenter: IContactProfilePresenter {

  var router: IContactProfileRouter
  var interactor: IContactProfileInteractor

  weak var view: IContactProfileView?

  init(interactor: IContactProfileInteractor, router: IContactProfileRouter) {
    self.interactor = interactor
    self.router = router
  }

  // MARK: - Public methods
  func closeProfile() {
    router.closeProfile()
  }

  func createContactDidPress() {
    interactor.startValidating()
    let isValid = interactor.validate()

    if !isValid {
      return
    }

    // TODO: mmk edit
    closeProfile()
  }

}

// MARK: - Configure fields
extension ContactProfilePresenter {

  func setupLastNameValidation(_ textField: TitledTextField) {
    interactor.setupLastNameValidation(textField)
  }

  func setupFirstNameValidation(_ textField: TitledTextField) {
    interactor.setupFirstNameValidation(textField)
  }

}
