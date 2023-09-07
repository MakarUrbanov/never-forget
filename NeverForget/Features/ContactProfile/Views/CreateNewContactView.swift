//
//  CreateNewContactView.swift
//  never-forget
//
//  Created by makar on 2/27/23.
//

import SwiftUI

struct CreateNewContactView: View {

  @StateObject private var viewModel: CreateNewContactViewModel

  init(goBack: @escaping () -> Void) {
    _viewModel = StateObject(wrappedValue: CreateNewContactViewModel(goBack: goBack))
  }

  var body: some View {
    NavigationView {
      BaseContactProfileView(person: $viewModel.person)
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            Button("Cancel") { // TODO: translate
              viewModel.onPressOnCancel()
            }
          }

          ToolbarItem(placement: .navigationBarTrailing) {
            Button("Add") { // TODO: translate
              viewModel.onPressAddNewPerson()
            }
          }
        }
    }
    .interactiveDismissDisabled()
  }
}

struct CreateNewPersonView_Previews: PreviewProvider {
  static var previews: some View {
    CreateNewContactView(goBack: {})
  }
}
