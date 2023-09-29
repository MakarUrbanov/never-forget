//
//  ContactProfileInteractor.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

import NFFormValidator
import UIKit

protocol IContactProfileInteractorInput: AnyObject {
  var contact: Contact { get }

  func saveContact()
  func discardChanged()

  func setContactImage(_ image: UIImage)
  func deleteContactImage()

  func addValidatorField(_ field: INFObservableField)
  func firstNameDidChange(_ firstName: String)
  func lastNameDidChange(_ lastName: String)
  func middleNameDidChange(_ middleName: String)
}

protocol IContactProfileInteractorOutput: AnyObject {
  func didSaveContact()
}

class ContactProfileInteractor: IContactProfileInteractorInput {

  // MARK: - Public properties
  weak var presenter: IContactProfileInteractorOutput?
  var contact: Contact

  // MARK: - Private properties
  private let formValidator = NFFormValidator()

  // MARK: - Init
  init(contact: Contact) {
    self.contact = contact
  }

  // MARK: - Public methods
  func saveContact() {
    startValidating()
    let isValid = validate()

    if !isValid {
      return
    }

    saveChanges()
    presenter?.didSaveContact()
  }

  func discardChanged() {
    rollbackChanges()
  }

  func setContactImage(_ image: UIImage) {
    contact.setPhotoAndResize(image) {}
  }

  func deleteContactImage() {
    contact.clearPhotoData()
  }

  func addValidatorField(_ field: INFObservableField) {
    formValidator.addField(field)
  }

  func firstNameDidChange(_ firstName: String) {
    contact.firstName = firstName
  }

  func lastNameDidChange(_ lastName: String) {
    contact.lastName = lastName
  }

  func middleNameDidChange(_ middleName: String) {
    contact.middleName = middleName
  }

}

// MARK: - Private methods
private extension ContactProfileInteractor {

  private func rollbackChanges() {
    contact.managedObjectContext?.rollback()
  }

  private func saveChanges() {
    contact.managedObjectContext?.saveChanges()
  }

  private func startValidating() {
    formValidator.startValidating()
  }

  private func validate() -> Bool {
    formValidator.validate()
  }

}
