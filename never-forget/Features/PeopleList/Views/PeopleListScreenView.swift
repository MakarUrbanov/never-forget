//
//  PeopleListScreenView.swift
//  never-forget
//
//  Created by makar on 2/19/23.
//

import SwiftUI

struct PeopleListScreenView: View {

  @EnvironmentObject var coordinator: PeopleListCoordinator
  @StateObject var viewModel = PeopleListScreenViewModel()

  var body: some View {
    VStack {
      PeopleListView()
    }
    .navigationTitle("Your friends list") // TODO: localize
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button("Add") { // TODO: localize
          viewModel.presentAddNewPerson(coordinator: coordinator)
        }
      }
    }
  }
}

struct PersonsListView_Previews: PreviewProvider {
  static var previews: some View {
    PeopleListScreenView()
  }
}
