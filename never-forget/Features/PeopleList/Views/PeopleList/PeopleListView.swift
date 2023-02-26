//
//  PeopleListView.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import SwiftUI

struct PeopleListView: View {

  @EnvironmentObject var coordinator: PeopleListCoordinator
  @Environment(\.managedObjectContext) var managedObjectContext

  @FetchRequest(fetchRequest: Person.sortedFetchRequest()) var persons
  @StateObject var viewModel = PeopleListViewModel()

  var body: some View {
    List(persons) { person in
      PersonCellView(person)
        .background(Color.Theme.background)
        .onTapGesture {
          viewModel.openPersonProfile(coordinator: coordinator, person: person)
        }
        .listRowBackground(Color.clear)
        .swipeActions(allowsFullSwipe: false, content: {
          Button("Delete") { // TODO: translate
            viewModel.deleteUser(managedObjectContext: managedObjectContext, person: person)
          }
        })
    }
    .listStyle(.plain)
    .background(Color.Theme.background)
  }
}

struct PeopleListView_Previews: PreviewProvider {
  static var previews: some View {
    PeopleListView()
  }
}
