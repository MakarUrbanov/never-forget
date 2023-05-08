//
//  ContactsListScreenView.swift
//  never-forget
//
//  Created by makar on 2/19/23.
//

import SwiftUI

struct ContactsListScreenView: View {

  @EnvironmentObject var coordinator: ContactsListCoordinator
  @StateObject var viewModel = ContactsListScreenViewModel()

  var body: some View {
    ContactsListView()
      .background(Color.Theme.background)
      .navigationTitle("Your contacts list") // TODO: translate
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Add") { // TODO: translate
            viewModel.presentAddNewPerson(coordinator: coordinator)
          }
        }
      }
  }
}

struct PeopleListScreenView_Previews: PreviewProvider {
  static var previews: some View {
    ContactsListScreenView()
  }
}
