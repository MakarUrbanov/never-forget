//
//  CreateNewPersonViewModel.swift
//  never-forget
//
//  Created by makar on 2/27/23.
//

import Foundation

class CreateNewPersonViewModel: ObservableObject {

  @Published var person: ValidatedValue<Person>

  let goBack: () -> Void

  init(person: Person, goBack: @escaping () -> Void) {
    self.goBack = goBack
    self.person = ValidatedValue(
      value: person,
      isValidateOnInit: true,
      validate: CreateNewPersonViewModel.validatePersonName
    )
  }

  func onPressAddNewPerson() {
    if person.isValid {
      createNewPerson()
    } else {
      onInvalidForm()
    }
  }

  func onPressOnCancel() {
    person.value.managedObjectContext?.rollback()
    goBack()
  }

}


extension CreateNewPersonViewModel {

  private func createNewPerson() {
    person.value.managedObjectContext?.saveSafely()
    goBack()
  }

  private func onInvalidForm() {
    person.editErrorVisibility(true)
  }

}


// MARK: - Validator

extension CreateNewPersonViewModel {

  private static func validatePersonName(_ person: Person) -> ValidatedValue<Person>.ValidatorResult {
    let isUsernameValid = !(person.name?.isEmpty ?? true)

    switch true {
      case isUsernameValid:
        return .init(isValid: true)
      default:
        return .init(isValid: false, errorMessage: "Enter name")
    }
  }

}
