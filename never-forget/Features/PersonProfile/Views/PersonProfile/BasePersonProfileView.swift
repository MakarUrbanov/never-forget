//
//  BasePersonProfileView.swift
//  never-forget
//
//  Created by makar on 2/27/23.
//

import SwiftUI

struct BasePersonProfileView: View {

  @Binding var person: ValidatedValue<Person>
  private var isValidUsername: Binding<Bool> { Binding(get: { !person.isVisibleError || person.isValid },
                                                       set: { _ in })
  }

  var body: some View {
    VStack {
      List {
        Section("Photo") {
          FormPhotoPickerView(imageData: $person.value.photo)
        }
        .listRowBackground(Color.clear)

        Section("Information") { // TODO: localize
          TextField("Name*", text: Binding($person.value.name, "")) // TODO: localize
            .listRowSeparator(.hidden, edges: .all)
            .foregroundColor(isValidUsername.wrappedValue ? Color.Theme.text : Color.Theme.error)
            .autocorrectionDisabled(true)
            .overlay(alignment: .bottom) {
              Divider()
                .background(isValidUsername.wrappedValue ? .clear : Color.Theme.error)
                .offset(CGSize(width: 0, height: 8))
            }

          TextField("Description", text: Binding($person.value.personDescription, "")) // TODO: localize
            .listRowSeparator(.hidden, edges: .all)
            .autocorrectionDisabled(true)
            .overlay(alignment: .bottom) {
              Divider()
                .offset(CGSize(width: 0, height: 8))
            }

          DatePicker(selection: Binding($person.value.dateOfBirth, Date()),
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
    let person = Person(context: PersistentContainerProvider.shared.viewContext)
    person.name = "User name"
    let validate: (Person) -> ValidatedValue<Person>.ValidatorResult = { _ in
      .init(isValid: false, errorMessage: "Error message")
    }

    return BasePersonProfileView(person: .constant(.init(value: person, validate: validate)))
  }
}
