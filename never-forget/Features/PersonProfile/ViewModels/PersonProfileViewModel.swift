//
//  PersonProfileViewModel.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import SwiftUI
import UIKit

final class PersonProfileViewModel: ObservableObject {

  @Published var person: ValidatedValue<Person>

  let goBack: () -> Void

  init(person: Person, goBack: @escaping () -> Void) {
    self.goBack = goBack
    self.person = ValidatedValue(value: person, isValidateOnInit: true,
                                 validate: PersonProfileViewModel.validatePersonName)
  }

  func validateAndSavePersonHandler() {
    if person.isValid {
      onValidForm()
    } else {
      onInvalidForm()
    }
  }

  func onDisappear() {
    person.value.managedObjectContext?.rollback()
  }

}

extension PersonProfileViewModel {

  private func onValidForm() {
    person.value.managedObjectContext?.saveSafely()
    goBack()
  }

  private func onInvalidForm() {
    person.editErrorVisibility(true)
  }

}

// MARK: - Validator

extension PersonProfileViewModel {

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
