//
//  AddNewPersonView.swift
//  never-forget
//
//  Created by makar on 2/24/23.
//

import SwiftUI

struct AddNewPersonView: View {

  @StateObject var viewModel = AddNewPersonViewModel()
  @Environment(\.dismiss) var dismiss

  var body: some View {
    NavigationView {
      List {
        Section("Information") { // TODO: localize
          TextField("Name*", text: $viewModel.name) // TODO: localize
          TextField("Description", text: $viewModel.description) // TODO: localize

          DatePicker(selection: $viewModel.dateOfBirth, in: ...Date(), displayedComponents: .date) {
            Text("Date of birth:") // TODO: localize
              .overlay(alignment: .topTrailing) {
                Text("*")
                  .foregroundColor(.Theme.text.dark(0.4))
                  .offset(x: 8, y: 0)
              }
          }
          .datePickerStyle(CompactDatePickerStyle())
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarLeading) {
          Button("Cancel") { // TODO: localize
            dismiss()
          }
        }
      }
    }
  }
}

struct CreateNewPersonView_Previews: PreviewProvider {
  static var previews: some View {
    AddNewPersonView()
  }
}
