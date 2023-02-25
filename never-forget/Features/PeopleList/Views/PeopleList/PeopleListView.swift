//
//  PeopleListView.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import SwiftUI

struct PeopleListView: View {

  @Environment(\.managedObjectContext) var managedObjectContext
  @FetchRequest(fetchRequest: Person.sortedFetchRequest(), animation: .easeInOut) var persons
  @StateObject var viewModel = PeopleListViewModel()

  @State var isPresented = false

  var body: some View {
    List {
      ForEach(persons) { person in
        PersonCellView(person)
          .listRowBackground(Color.clear)
          .swipeActions(allowsFullSwipe: false, content: {
            Button("Delete") { // TODO: translate
              viewModel.deleteUser(managedObjectContext: managedObjectContext, person: person)
            }
          })
      }
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
