//
//  CreateNewPersonViewModel.swift
//  never-forget
//
//  Created by makar on 2/27/23.
//

import Foundation

class CreateNewPersonViewModel: ObservableObject {

  @Published var person: Person
  let goBack: () -> Void

  init(person: Person, goBack: @escaping () -> Void) {
    self.person = person
    self.goBack = goBack
  }

  func createNewPerson() {
    person.managedObjectContext?.saveSafely()
    goBack()
  }

  func cancel() {
    person.managedObjectContext?.rollback()
    goBack()
  }

}
