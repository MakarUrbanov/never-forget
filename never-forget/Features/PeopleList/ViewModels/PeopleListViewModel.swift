//
//  PeopleListViewModel.swift
//  never-forget
//
//  Created by makar on 2/25/23.
//

import CoreData
import SwiftUI

class PeopleListViewModel: ObservableObject {

  func deleteUser(managedObjectContext: NSManagedObjectContext, person: Person) {
    askToDelete { [weak self] in
      print("DELETE")
      managedObjectContext.delete(person)
      self?.saveContext()
    }
  }

  func openPersonProfile(coordinator: PeopleListCoordinator, person: Person) {
    coordinator.openPersonProfile(person: person)
  }

}

extension PeopleListViewModel {

  private func askToDelete(delete: @escaping () -> Void) {
    let yesButtonOptions: AlertManager.AlertButtonOptions = (title: "Yes", style: .destructive, handler: { _ in
      print("delete")
      delete()
    })
    let noButtonOptions: AlertManager.AlertButtonOptions = (title: "No", style: .default, handler: { _ in
      print("Do not delete")
    })

    AlertManager.shared
      .show(title: "Delete person?", buttonOptions: [yesButtonOptions, noButtonOptions]) // TODO: translate
  }

  private func saveContext() {
    PersistentContainerProvider.shared.saveContext()
  }

}
