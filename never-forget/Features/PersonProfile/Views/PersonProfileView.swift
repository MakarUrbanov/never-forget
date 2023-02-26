//
//  PersonProfileView.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import PhotosUI
import SwiftUI

struct PersonProfileView: View {

  let isEditMode: Bool
  @StateObject var viewModel: PersonProfileViewModel
  @State var selectedPhotos: [PhotosPickerItem] = []

  init(person: Person? = nil, goBack: @escaping () -> Void) {
    isEditMode = person != nil
    let person = person ?? Person(context: PersistentContainerProvider.shared.backgroundContext)
    _viewModel = StateObject(wrappedValue: PersonProfileViewModel(person: person, goBack: goBack))
  }

  var body: some View {
    NavigationView {
      VStack {
        List {
          Section("Photo") {
            FormPhotoPickerView(selectedPhotos: $selectedPhotos, imageData: $viewModel.person.photo)
          }
          .listRowBackground(Color.clear)

          Section("Information") { // TODO: localize
            TextField("Name*", text: Binding($viewModel.person.name, "")) // TODO: localize
            TextField("Description", text: Binding($viewModel.person.personDescription, "")) // TODO: localize

            DatePicker(selection: Binding($viewModel.person.dateOfBirth, Date()),
                       in: ...Date(),
                       displayedComponents: .date) {
              Text("Date of birth:*") // TODO: localize
            }
            .datePickerStyle(CompactDatePickerStyle())
          }
        }
        .listStyle(.insetGrouped)
        .background(Color.Theme.background)
        .scrollContentBackground(.hidden)
      }
      .toolbar {
        PersonProfileHeaderButtons(isEditMode: isEditMode,
                                   goBack: viewModel.goBack,
                                   save: viewModel.tryToSavePersonHandler,
                                   add: viewModel.tryToSavePersonHandler)
      }
    }
  }
}

struct CreateNewPersonView_Previews: PreviewProvider {
  static var previews: some View {
    PersonProfileView(goBack: {})
  }
}
