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

  let goBack: () -> Void

  init(goBack: @escaping () -> Void) {
    goBack = goBack
  }

  func createNewPersonHandler() {
    let isValidForm = !name.trimmed.isEmpty

    if isValidForm {
      createNewPerson()
    } else {
      // TODO: add handling error
    }
  }

}

extension AddNewPersonViewModel {

  func createNewPerson() {
    let person = Person(context: PersistentContainerProvider.shared.viewContext)
    person.name = name
    person.dateOfBirth = dateOfBirth
    person.personDescription = description.trimmed.isEmpty ? nil : description
    person.events = []
  }

}
