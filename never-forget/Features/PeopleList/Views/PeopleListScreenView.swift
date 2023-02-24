//
//  PeopleListScreenView.swift
//  never-forget
//
//  Created by makar on 2/19/23.
//

import SwiftUI

struct PeopleListScreenView: View {

  @StateObject private var listTabPersistentContainer = ListTabContainerProvider.shared

  var body: some View {
    VStack {
      PeopleListView()
    }
    .environment(\.managedObjectContext, listTabPersistentContainer.viewContext)
    .navigationTitle("Test123")
  }
}

struct PersonsListView_Previews: PreviewProvider {
  static var previews: some View {
    PeopleListScreenView()
  }
}
