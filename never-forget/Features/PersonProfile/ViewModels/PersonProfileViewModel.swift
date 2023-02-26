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

  func tryToSavePersonHandler() {
    let isValidForm = !(person.name?.trimmed.isEmpty ?? true)

    if isValidForm {
      onValidForm()
    } else {
      onInvalidForm()
    }
  }

}

extension PersonProfileViewModel {

  private func saveContext() {
    PersistentContainerProvider.shared.saveContext()
  }

  private func getNewPerson() {
  }

  func editPerson() {
    saveContext()
  }

  private func onValidForm() {
    getNewPerson()
    saveContext()
    goBack()
  }

  private func onInvalidForm() {
    AlertManager.shared.show(title: "Error", message: "Form error") // TODO: localize
  }

}
