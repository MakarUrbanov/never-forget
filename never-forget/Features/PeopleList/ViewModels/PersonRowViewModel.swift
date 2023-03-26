//
//  PersonRowViewModel.swift
//  never-forget
//
//  Created by makar on 3/5/23.
//

import Foundation

class PersonRowViewModel: ObservableObject {

  func openPersonProfile(coordinator: PeopleListCoordinator, person: Person) {
    coordinator.openPersonProfile(person: person)
  }

}
