//
//  PersonsListView.swift
//  never-forget
//
//  Created by makar on 2/19/23.
//

import SwiftUI

struct PersonsListView: View {

  @FetchRequest(fetchRequest: Person.sortedFetchRequest(), animation: .easeInOut) var persons

  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      ForEach(persons) { person in
        PersonCellView(person)
      }
    }
  }
}

struct PersonsListView_Previews: PreviewProvider {
  static var previews: some View {
    PersonsListView()
  }
}
