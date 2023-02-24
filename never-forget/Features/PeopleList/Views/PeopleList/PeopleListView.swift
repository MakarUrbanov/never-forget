//
//  PeopleListView.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import SwiftUI

struct PeopleListView: View {

  @FetchRequest(fetchRequest: Person.sortedFetchRequest(), animation: .easeInOut) var persons

  var body: some View {
    List {
      ForEach(persons) { person in
        PersonCellView(person)
      }
    }
    .listStyle(PlainListStyle())
  }
}

struct PeopleListView_Previews: PreviewProvider {
  static var previews: some View {
    PeopleListView()
  }
}
