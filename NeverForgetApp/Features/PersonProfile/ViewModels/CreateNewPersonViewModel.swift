//
//  CreateNewPersonViewModel.swift
//  never-forget
//
//  Created by makar on 2/27/23.
//

import Foundation

class CreateNewPersonViewModel: ObservableObject {

  @Published var person: ValidatedValue<Person>
  private let personNotificationsManager = PersonsNotificationsManager()

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
    scheduleNotifications()
    goBack()
  }

  private func onInvalidForm() {
    person.editErrorVisibility(true)
  }

  private func scheduleNotifications() {
    Task {
      do {
        try await personNotificationsManager.rescheduleBirthdayNotifications(for: person.value)
      } catch {
        Logger.error(message: "Scheduling notifications error", error)
      }
    }
  }

}


// MARK: - Validator

extension CreateNewPersonViewModel {

  private static func validatePersonName(_ person: Person) -> ValidatedValue<Person>.ValidatorResult {
    let isUsernameValid = !person.name.isEmpty

    switch true {
      case isUsernameValid:
        return .init(isValid: true)
      default:
        return .init(isValid: false, errorMessage: "Enter name")
    }
  }

}
