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
    askToDelete {
      managedObjectContext.delete(person)
      managedObjectContext.saveSafely()
    }
  }

}

extension PeopleListViewModel {

  private func askToDelete(delete: @escaping () -> Void) {
    let yesButtonOptions: AlertManager.AlertButtonOptions = (title: "Yes", style: .destructive, handler: { _ in
      delete()
    })
    let noButtonOptions: AlertManager.AlertButtonOptions = (title: "No", style: .default, handler: { _ in
    })

    AlertManager.shared.show(
      title: "Delete person?",
      buttonOptions: [yesButtonOptions, noButtonOptions]
    ) // TODO: translate
  }

}
