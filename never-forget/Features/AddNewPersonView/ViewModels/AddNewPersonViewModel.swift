//
//  AddNewPersonViewModel.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import UIKit

final class AddNewPersonViewModel: ObservableObject {

  @Published var name = ""
  @Published var dateOfBirth = Date()
  @Published var description = ""

  @Published var imageData: Data?

  let goBack: () -> Void

  init(goBack: @escaping () -> Void) {
    self.goBack = goBack
  }

  func createNewPersonHandler() {
    let isValidForm = !name.trimmed.isEmpty

    if isValidForm {
      onValidForm()
    } else {
      onInvalidForm()
    }
  }

}

extension AddNewPersonViewModel {

  private func saveContext() {
    PersistentContainerProvider.shared.saveContext()
  }

  private func createNewPerson() {
    let person = Person(context: PersistentContainerProvider.shared.viewContext)
    person.name = name
    person.dateOfBirth = dateOfBirth
    person.personDescription = description.trimmed.isEmpty ? nil : description
    person.events = []
    person.photo = imageData
  }

  private func onValidForm() {
    createNewPerson()
    saveContext()
    goBack()
  }

  private func onInvalidForm() {
    AlertManager.shared.show(with: "Error", and: "Form error") // TODO: localize
  }

}
