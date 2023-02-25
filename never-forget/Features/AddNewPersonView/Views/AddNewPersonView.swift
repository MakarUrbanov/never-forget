//
//  AddNewPersonView.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import PhotosUI
import SwiftUI

struct AddNewPersonView: View {

  @StateObject var viewModel: AddNewPersonViewModel
  @State var selectedPhotos: [PhotosPickerItem] = []

  init(goBack: @escaping () -> Void) {
    _viewModel = StateObject(wrappedValue: AddNewPersonViewModel(goBack: goBack))
  }

  var body: some View {
    NavigationView {
      VStack {
        List {
          Section("Photo") {
            FormPhotoPickerView(selectedPhotos: $selectedPhotos, imageData: $viewModel.imageData)
          }
          .listRowBackground(Color.clear)

          Section("Information") { // TODO: localize
            TextField("Name*", text: $viewModel.name) // TODO: localize
            TextField("Description", text: $viewModel.description) // TODO: localize

            DatePicker(selection: $viewModel.dateOfBirth, in: ...Date(), displayedComponents: .date) {
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
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") { // TODO: localize
            viewModel.goBack()
          }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
          Button("Add") { // TODO: localize
            viewModel.createNewPersonHandler()
          }
        }
      }
    }
  }
}

struct CreateNewPersonView_Previews: PreviewProvider {
  static var previews: some View {
    AddNewPersonView(goBack: {})
  }
}
