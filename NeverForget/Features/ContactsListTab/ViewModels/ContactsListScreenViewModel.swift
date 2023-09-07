//
//  ContactsListScreenViewModel.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import SwiftUI

final class ContactsListScreenViewModel: ObservableObject {

  func presentAddNewPerson(coordinator: ContactsListCoordinator) {
    coordinator.presentCreateNewPersonView()
  }

}
