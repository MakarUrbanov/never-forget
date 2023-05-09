//
//  ContactProfileViewModel.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import CoreData
import SwiftUI
import UIKit

final class ContactProfileViewModel: ObservableObject {

  @Published var person: ValidatedValue<Person>
  private let personNotificationsManager = ContactNotificationsManager()

  let goBack: () -> Void

  init(person: Person, context: NSManagedObjectContext, goBack: @escaping () -> Void) {
    self.goBack = goBack
    // swiftlint:disable:next force_unwrapping
    let personInNewContext = CoreDataWrapper.shared.existingObject(person, in: context)!
    self.person = ValidatedValue(
      value: personInNewContext,
      isValidateOnInit: true,
      validate: ContactProfileViewModel.validatePersonName
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

extension ContactProfileViewModel {

  private func onValidForm() {
    person.value.managedObjectContext?.saveChanges()
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

extension ContactProfileViewModel {

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
