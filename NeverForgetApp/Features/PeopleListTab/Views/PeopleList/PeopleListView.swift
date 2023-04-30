//
//  PeopleListView.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import CoreData
import OSLog
import SwiftUI

struct PeopleListView: View {

  @EnvironmentObject var coordinator: PeopleListCoordinator
  @Environment(\.managedObjectContext) var managedObjectContext

  @FetchRequest(fetchRequest: Person.sortedFetchRequest()) var persons
  @StateObject var viewModel = PeopleListViewModel()

  var body: some View {
    VStack {
      if persons.isEmpty {
        PeopleListWelcomeMessage()
      } else {
        List {
          Group {
            ForEach(persons) { person in
              PersonRowView(person, openPersonProfile: coordinator.openPersonProfile(person:))
                .listRowBackground(Color.clear)
                .swipeActions(allowsFullSwipe: false, content: {
                  Button("Delete") { // TODO: translate
                    viewModel.deleteUser(managedObjectContext: managedObjectContext, person: person)
                  }
                  .tint(.red)
                })
            }
          }
          .listRowBackground(Color.clear)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
      }
    }
    .background(Color.clear)
  }
}

struct PeopleListView_Previews: PreviewProvider {

  private static func addPerson() {
    let newPerson = Person(context: PersistentContainerProvider.shared.viewContext)
    newPerson.name = .randomString(maxLength: 20, numberOfWords: 2)
    newPerson.photo = Bool.random() ? UIImage(named: "MockImage")?.jpegData(compressionQuality: 1) : nil
    newPerson.dateOfBirth = Date.getRandomDate()

    PersistentContainerProvider.shared.viewContext.saveSafely()
  }

  private static func deletePersons() {
    let persons = try? PersistentContainerProvider.shared.viewContext.fetch(Person.fetchRequest()) as? [Person]

    persons?.forEach { person in
      PersistentContainerProvider.shared.viewContext.delete(person)
    }

    PersistentContainerProvider.shared.viewContext.saveSafely()
  }

  static var previews: some View {
    ZStack(alignment: .bottom) {
      PeopleListView()
        .environment(\.managedObjectContext, PersistentContainerProvider.shared.viewContext)
        .environmentObject(PeopleListCoordinator())

      VStack {
        Button("Add person") {
          addPerson()
        }
        Button("Delete persons") {
          deletePersons()
        }
      }
    }
  }
}
