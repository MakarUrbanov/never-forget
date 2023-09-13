//
//  BaseContactProfileView.swift
//  never-forget
//
//  Created by makar on 2/27/23.
//

import SwiftUI

struct BaseContactProfileView: View {

  @Binding var person: ValidatedValue<Person>
  private var isValidUsername: Bool {
    !person.isVisibleError || person.isValid
  }

  var body: some View {
    VStack {
      List {
        Section("Photo") {
          FormPhotoPickerView(imageData: $person.value.photo)
        }
        .listRowBackground(Color.clear)

        Section("Information") { // TODO: translate
          TextField("Name *", text: $person.value.name) // TODO: translate
            .listRowSeparator(.hidden, edges: .all)
            .foregroundColor(isValidUsername ? Color(.text) : Color(.error100))
            .autocorrectionDisabled(true)
            .overlay(alignment: .bottom) {
              Divider()
                .background(isValidUsername ? .clear : Color(.error100))
                .offset(CGSize(width: 0, height: 8))
            }

          TextField("Description", text: $person.value.personDescription) // TODO: translate
            .listRowSeparator(.hidden, edges: .all)
            .autocorrectionDisabled(true)
            .overlay(alignment: .bottom) {
              Divider()
                .offset(CGSize(width: 0, height: 8))
            }

          DatePicker(
            selection: $person.value.dateOfBirth,
            in: ...Date(),
            displayedComponents: .date
          ) {
            Text("Date of birth: *") // TODO: translate
          }
          .datePickerStyle(CompactDatePickerStyle())

          Toggle("Notifications enabled", isOn: $person.value.isNotificationsEnabled) // TODO: translate
        }
      }
      .listStyle(.insetGrouped)
      .scrollContentBackground(.hidden)

      ContactNotificationsPermissionInfoBlockView(person: $person.value)
        .padding(.horizontal)
        .padding(.bottom)
    }
    .background(Color(.darkBackground))
  }
}

struct BasePersonProfileView_Previews: PreviewProvider {
  static var previews: some View {
    let person = Person(context: CoreDataStack.shared.viewContext)
    person.name = "User name"
    let validate: (Person) -> ValidatedValue<Person>.ValidatorResult = { _ in
      .init(isValid: false, errorMessage: "Error message")
    }

    return BaseContactProfileView(person: .constant(.init(value: person, validate: validate)))
  }
}
