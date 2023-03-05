//
//  PeopleListView.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import CoreData
import SwiftUI

struct PeopleListView: View {

  @EnvironmentObject var coordinator: PeopleListCoordinator
  @Environment(\.managedObjectContext) var managedObjectContext

  @FetchRequest(fetchRequest: Person.sortedFetchRequest()) var persons
  @StateObject var viewModel = PeopleListViewModel()

  var body: some View {
    List(persons) { person in
      PersonRowView(person)
        .background(Color.Theme.background)
        .listRowBackground(Color.clear)
        .swipeActions(allowsFullSwipe: false, content: {
          Button("Delete") { // TODO: translate
            viewModel.deleteUser(managedObjectContext: managedObjectContext, person: person)
          }
          .tint(.red)
        })
    }
    .listStyle(.plain)
    .background(Color.Theme.background)
  }
}

struct PeopleListView_Previews: PreviewProvider {

  static var previews: some View {
    for _ in 0 ..< 3 {
      let newPerson = Person(context: PersistentContainerProvider.shared.viewContext)
      newPerson.name = .randomString(maxLength: 20, numberOfWords: 2)
    }

    PersistentContainerProvider.shared.viewContext.saveSafely()

    return PeopleListView()
      .environment(\.managedObjectContext, PersistentContainerProvider.shared.viewContext)
      .environmentObject(PeopleListCoordinator())
  }
}
