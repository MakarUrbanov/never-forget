//
//  ContactProfilePresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

import UIKit

protocol IContactProfilePresenter: AnyObject {
  func viewDidLoad()
  func closeProfile()
  func createContactDidPress()
  func setupLastNameValidation(_ textField: TitledTextField)
  func setupFirstNameValidation(_ textField: TitledTextField)
  func setInitialContactsFields(_ contact: Contact)
  func setContactImage(_ image: UIImage)
  func deleteContactImage()
}

class ContactProfilePresenter: IContactProfilePresenter {

  var router: IContactProfileRouter
  var interactor: IContactProfileInteractor

  weak var view: IContactProfileView?

  init(interactor: IContactProfileInteractor, router: IContactProfileRouter) {
    self.interactor = interactor
    self.router = router
  }

  func viewDidLoad() {
    setInitialContactsFields(interactor.contact)
  }

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

  func setInitialContactsFields(_ contact: Contact) {
    view?.setupInitialFirstName(contact.firstName)
    view?.setupInitialLastName(contact.lastName ?? "")
    view?.setupInitialMiddleName(contact.middleName ?? "")

    if let photoData = contact.photoData, let contactImage = UIImage(data: photoData) {
      view?.setupInitialUsersImage(contactImage)
    }
  }

  func setContactImage(_ image: UIImage) {
    interactor.setContactImage(image)
  }

  func deleteContactImage() {}

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
