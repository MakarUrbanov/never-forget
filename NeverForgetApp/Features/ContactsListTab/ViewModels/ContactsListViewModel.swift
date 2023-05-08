//
//  ContactsListViewModel.swift
//  never-forget
//
//  Created by makar on 2/25/23.
//

import CoreData
import SwiftUI

class ContactsListViewModel: ObservableObject {

  private let personsNotificationsManager = ContactNotificationsManager()

  func deleteUser(managedObjectContext: NSManagedObjectContext, person: Person) {
    let deletePerson: () -> Void = {
      let userId = ContactNotificationsManager.getUserIdFromPersonObject(person)

      Task {
        await self.personsNotificationsManager.deleteAllNotifications(withPrefix: userId)
      }

      managedObjectContext.delete(person)
      managedObjectContext.saveSafely()
    }

    askToDelete(personName: person.name, delete: deletePerson)
  }

}

extension ContactsListViewModel {

  private func askToDelete(personName: String, delete: @escaping () -> Void) {
    let yesButtonOptions: AppAlertManager.AlertButtonOptions = (title: "Yes", style: .destructive, handler: { _ in
      delete()
    })
    let noButtonOptions: AppAlertManager.AlertButtonOptions = (title: "No", style: .default, handler: { _ in
    })

    AppAlertManager.shared.show(
      title: "Delete \(personName)?", // TODO: translate
      buttonOptions: [yesButtonOptions, noButtonOptions]
    )
  }

}
