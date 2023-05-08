//
//  PersonProfileView.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import SwiftUI

struct ContactProfileView: View {

  @StateObject private var viewModel: ContactProfileViewModel

  init(person: Person, goBack: @escaping () -> Void) {
    let existsPerson: Person? = PersistentContainerProvider.shared.exists(
      person,
      in: PersistentContainerProvider
        .shared
        .backgroundContext
    )
    let correctPerson = existsPerson ?? Person(context: PersistentContainerProvider.shared.backgroundContext)
    _viewModel = StateObject(wrappedValue: ContactProfileViewModel(person: correctPerson, goBack: goBack))
  }

  var body: some View {
    BaseContactProfileView(person: $viewModel.person)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") { // TODO: translate
            viewModel.validateAndSavePersonHandler()
          }
        }
      }
      .onDisappear {
        viewModel.onDisappear()
      }
  }
}

struct PersonProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ContactProfileView(person: Person(context: PersistentContainerProvider.shared.viewContext), goBack: {})
  }
}
