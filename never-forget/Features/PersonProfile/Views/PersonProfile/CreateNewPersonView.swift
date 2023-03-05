//
//  CreateNewPersonView.swift
//  never-forget
//
//  Created by makar on 2/27/23.
//

import SwiftUI

struct CreateNewPersonView: View {

  @StateObject private var viewModel: CreateNewPersonViewModel

  init(goBack: @escaping () -> Void) {
    let person = Person(context: PersistentContainerProvider.shared.backgroundContext)
    _viewModel = StateObject(wrappedValue: CreateNewPersonViewModel(person: person, goBack: goBack))
  }

  var body: some View {
    NavigationView {
      BasePersonProfileView(photo: $viewModel.person.photo,
                            name: $viewModel.person.name,
                            personDescription: $viewModel.person.personDescription,
                            dateOfBirth: $viewModel.person.dateOfBirth)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") { // TODO: localize
              viewModel.cancel()
            }
          }

          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Add") { // TODO: localize
              viewModel.createNewPerson()
            }
          }
        }
    }
    .interactiveDismissDisabled()
  }
}

struct CreateNewPersonView_Previews: PreviewProvider {
  static var previews: some View {
    CreateNewPersonView(goBack: {})
  }
}
