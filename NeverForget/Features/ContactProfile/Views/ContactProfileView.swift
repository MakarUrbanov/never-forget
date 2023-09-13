//
//  ContactProfileView.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import SwiftUI

struct ContactProfileView: View {

  @StateObject private var viewModel: ContactProfileViewModel

  init(person: Person, goBack: @escaping () -> Void) {
    _viewModel = StateObject(wrappedValue: ContactProfileViewModel(
      person: person,
      context: CoreDataStack.shared.backgroundContext,
      goBack: goBack
    ))
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
    ContactProfileView(person: Person(context: CoreDataStack.shared.viewContext), goBack: {})
  }
}
