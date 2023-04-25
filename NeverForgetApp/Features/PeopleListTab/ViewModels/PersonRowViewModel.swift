//
//  PersonRowViewModel.swift
//  never-forget
//
//  Created by makar on 3/5/23.
//

import Foundation

class PersonRowViewModel: ObservableObject {

  let person: Person
  private let openPersonProfile: (Person) -> Void

  init(person: Person, openPersonProfile: @escaping (Person) -> Void) {
    self.person = person
    self.openPersonProfile = openPersonProfile
  }

  func openPersonProfileHandler() {
    openPersonProfile(person)
  }

}
