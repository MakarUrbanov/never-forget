//
//  PersonProfileView.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import SwiftUI

struct PersonProfileView: View {

  @StateObject private var viewModel: PersonProfileViewModel

  init(person: Person, goBack: @escaping () -> Void) {
    let existsPerson: Person? = PersistentContainerProvider.shared.exists(person,
                                                                          in: PersistentContainerProvider
                                                                            .shared
                                                                            .backgroundContext)
    let correctPerson = existsPerson ?? Person(context: PersistentContainerProvider.shared.backgroundContext)
    _viewModel = StateObject(wrappedValue: PersonProfileViewModel(person: correctPerson, goBack: goBack))
  }

  var body: some View {
    BasePersonProfileView(person: $viewModel.person)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Save") { // TODO: localize
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
    PersonProfileView(person: Person(context: PersistentContainerProvider.shared.viewContext), goBack: {})
  }
}
