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
  private let personNotificationsManager = PersonsNotificationsManager()

  let goBack: () -> Void

  init(person: Person, goBack: @escaping () -> Void) {
    self.goBack = goBack
    self.person = ValidatedValue(
      value: person,
      isValidateOnInit: true,
      validate: PersonProfileViewModel.validatePersonName
    )
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
    rescheduleNotifications()
    goBack()
  }

  private func onInvalidForm() {
    person.editErrorVisibility(true)
  }

  private func rescheduleNotifications() {
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

extension PersonProfileViewModel {

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
