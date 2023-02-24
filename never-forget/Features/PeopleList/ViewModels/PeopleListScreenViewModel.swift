//
//  PeopleListScreenViewModel.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import SwiftUI

final class PeopleListScreenViewModel: ObservableObject {

  func presentAddNewPerson(coordinator: PeopleListCoordinator) {
    coordinator.presentAddNewPersonView()
  }

}
