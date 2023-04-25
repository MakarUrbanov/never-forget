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
      List(persons) { person in
        PersonRowView(person, openPersonProfile: coordinator.openPersonProfile(person:))
          .listRowBackground(Color.clear)
          .swipeActions(allowsFullSwipe: false, content: {
            Button("Delete") { // TODO: translate
              viewModel.deleteUser(managedObjectContext: managedObjectContext, person: person)
            }
            .tint(.red)
          })
      }
      .listStyle(.plain)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.Theme.background)
  }
}

struct PeopleListView_Previews: PreviewProvider {

  static var previews: some View {
    let newPerson = Person(context: PersistentContainerProvider.shared.viewContext)
    newPerson.name = .randomString(maxLength: 20, numberOfWords: 2)
    newPerson.photo = Bool.random() ? UIImage(named: "MockImage")?.jpegData(compressionQuality: 1) : nil
    newPerson.dateOfBirth = Date.getRandomDate()

    return PeopleListView()
      .environment(\.managedObjectContext, PersistentContainerProvider.shared.viewContext)
      .environmentObject(PeopleListCoordinator())
  }
}
