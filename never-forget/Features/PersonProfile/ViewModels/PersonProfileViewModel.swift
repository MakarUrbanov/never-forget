//
//  PersonProfileViewModel.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import UIKit

final class PersonProfileViewModel: ObservableObject {

  @Published var person: Person
  let goBack: () -> Void

  init(person: Person, goBack: @escaping () -> Void) {
    self.goBack = goBack
    self.person = person
  }

  func validateAndSavePersonHandler() {
    let isValidForm = !(person.name?.trimmed.isEmpty ?? true)

    if isValidForm {
      onValidForm()
    } else {
      onInvalidForm()
    }
  }

  func onDisappear() {
    person.managedObjectContext?.rollback()
  }

}

extension PersonProfileViewModel {

  private func onValidForm() {
    person.managedObjectContext?.saveSafely()
    goBack()
  }

  private func onInvalidForm() {
    AlertManager.shared.show(title: "Error", message: "Form error") // TODO: localize
  }

}
