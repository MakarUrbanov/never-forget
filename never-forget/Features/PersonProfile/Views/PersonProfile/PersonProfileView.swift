//
//  PersonProfileView.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import PhotosUI
import SwiftUI

struct PersonProfileView: View {

  @StateObject var viewModel: PersonProfileViewModel
  @State var selectedPhotos: [PhotosPickerItem] = []

  init(person: Person? = nil, goBack: @escaping () -> Void) {
    let person = person ?? Person(context: PersistentContainerProvider.shared.backgroundContext)
    _viewModel = StateObject(wrappedValue: PersonProfileViewModel(person: person, goBack: goBack))
  }

  var body: some View {
    BasePersonProfileView(selectedPhotos: $selectedPhotos,
                          photo: $viewModel.person.photo,
                          name: $viewModel.person.name,
                          personDescription: $viewModel.person.personDescription,
                          dateOfBirth: $viewModel.person.dateOfBirth)
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
    PersonProfileView(goBack: {})
  }
}
