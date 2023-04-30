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
    PeopleListView()
      .background(Color.Theme.background)
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

struct PeopleListScreenView_Previews: PreviewProvider {
  static var previews: some View {
    PeopleListScreenView()
  }
}
