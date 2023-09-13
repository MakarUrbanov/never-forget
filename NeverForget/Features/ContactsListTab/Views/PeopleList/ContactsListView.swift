//
//  ContactsListView.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import CoreData
import OSLog
import SwiftUI

struct ContactsListView: View {

  @EnvironmentObject var coordinator: ContactsListCoordinator
  @Environment(\.managedObjectContext) var managedObjectContext

  @FetchRequest(fetchRequest: Person.sortedFetchRequest()) var persons
  @StateObject var viewModel = ContactsListViewModel()

  var body: some View {
    VStack {
      if persons.isEmpty {
        ContactsListWelcomeMessageView()
      } else {
        List {
          Group {
            ForEach(persons) { person in
              ContactRowView(person, openPersonProfile: coordinator.openPersonProfile(person:))
                .listRowBackground(Color.clear)
                .swipeActions(allowsFullSwipe: false, content: {
                  Button("Delete") { // TODO: translate
                    viewModel.deleteUser(context: managedObjectContext, person: person)
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

  private static let context = CoreDataStack.shared.viewContext

  private static func addPerson() {
    let newPerson = Person(context: context)
    newPerson.name = .randomString(maxLength: 20, numberOfWords: 2)
    newPerson.photo = Bool.random() ? UIImage(named: "MockImage")?.jpegData(compressionQuality: 1) : nil
    newPerson.dateOfBirth = Date.getRandomDate()

    context.saveChanges()
  }

  private static func deletePersons() {
    let persons = try? context.fetch(Person.fetchRequest()) as? [Person]

    persons?.forEach { person in
      context.delete(person)
    }

    context.saveChanges()
  }

  static var previews: some View {
    ZStack(alignment: .bottom) {
      ContactsListView()
        .environment(\.managedObjectContext, context)
        .environmentObject(ContactsListCoordinator())

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
