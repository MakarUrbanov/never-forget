//
//  ContactProfilePresenter.swift
//  NeverForget
//
//  Created by Makar Mishchenko on 21.09.2023
//

import NFFormValidator
import UIKit

protocol IContactProfilePresenterInput: AnyObject {
  // Lifecycle
  func viewDidLoad()
  func viewDidDisappear()
  // Navigation
  func didPressSaveContact()
  func didPressCloseProfile()
  // Model
  func setContactImage(_ image: UIImage)
  func didPressDeleteContactImage()
  func addValidatorField(_ field: INFObservableField)
  func didChangeFirstName(_ firstName: String)
  func didChangeLastName(_ lastName: String)
  func didChangeMiddleName(_ middleName: String)
  func goToBirthdayEventScreen()
}

protocol IContactProfilePresenterOutput: AnyObject {
  func setLastName(_ lastName: String)
  func setFirstName(_ firstName: String)
  func setMiddleName(_ middleName: String)
  func setContactImage(_ image: UIImage)
  func setDateOfBirth(_ date: Date)
  func deleteContactImage()
}

class ContactProfilePresenter {

  private var router: IContactProfileRouter
  private var interactor: IContactProfileInteractorInput

  weak var view: IContactProfilePresenterOutput?

  init(interactor: IContactProfileInteractorInput, router: IContactProfileRouter) {
    self.interactor = interactor
    self.router = router
  }

}

// MARK: - View -> Presenter
extension ContactProfilePresenter: IContactProfilePresenterInput {

  func viewDidLoad() {
    setInitialContactsFields(interactor.contact)
  }

  func viewDidDisappear() {
    interactor.discardChanged()
  }

  func didPressSaveContact() {
    interactor.saveContact()
  }

  func didPressCloseProfile() {
    router.closeProfile()
    interactor.discardChanged()
  }

  func setContactImage(_ image: UIImage) {
    interactor.setContactImage(image)
  }

  func didPressDeleteContactImage() {
    interactor.deleteContactImage()
  }

  func addValidatorField(_ field: INFObservableField) {
    interactor.addValidatorField(field)
  }

  func didChangeFirstName(_ firstName: String) {
    interactor.firstNameDidChange(firstName)
  }

  func didChangeLastName(_ lastName: String) {
    interactor.lastNameDidChange(lastName)
  }

  func didChangeMiddleName(_ middleName: String) {
    interactor.middleNameDidChange(middleName)
  }

  func goToBirthdayEventScreen() {
    if let birthdayEvent = interactor.contact.birthdayEvent {
      router.goToEventScreen(event: birthdayEvent)
    }
  }

}

// MARK: - IContactProfileInteractorOutput
extension ContactProfilePresenter: IContactProfileInteractorOutput {

  func didSaveContact() {
    router.closeProfile()
  }

}

// MARK: - Private methods
private extension ContactProfilePresenter {

  private func setInitialContactsFields(_ contact: Contact) {
    view?.setFirstName(contact.firstName)
    view?.setLastName(contact.lastName ?? "")
    view?.setMiddleName(contact.middleName ?? "")

    if let birthdayEvent = contact.birthdayEvent {
      view?.setDateOfBirth(birthdayEvent.originDate)
    }

    if let photoData = contact.photoData, let contactImage = UIImage(data: photoData) {
      view?.setContactImage(contactImage)
    }
  }

}
