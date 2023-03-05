//
//  BasePersonProfileView.swift
//  never-forget
//
//  Created by makar on 2/27/23.
//

import PhotosUI
import SwiftUI

struct BasePersonProfileView: View {

  @Binding var selectedPhotos: [PhotosPickerItem]
  @Binding var photo: Data?
  @Binding var name: String?
  @Binding var personDescription: String?
  @Binding var dateOfBirth: Date?

  var body: some View {
    VStack {
      List {
        Section("Photo") {
          // FIXME: фризит при открытии на фотке 2МБ
          FormPhotoPickerView(selectedPhotos: $selectedPhotos, imageData: $photo)
        }
        .listRowBackground(Color.clear)

        Section("Information") { // TODO: localize
          TextField("Name*", text: Binding($name, "")) // TODO: localize
            .autocorrectionDisabled(true)
          TextField("Description", text: Binding($personDescription, "")) // TODO: localize
            .autocorrectionDisabled(true)

          DatePicker(selection: Binding($dateOfBirth, Date()),
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
  }
}

struct BasePersonProfileView_Previews: PreviewProvider {
  static var previews: some View {
    BasePersonProfileView(selectedPhotos: .constant([]),
                          photo: .constant(nil),
                          name: .constant("Name"),
                          personDescription: .constant("Description"),
                          dateOfBirth: .constant(Date()))
  }
}
