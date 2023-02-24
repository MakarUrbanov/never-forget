//
//  PersonCellView.swift
//  never-forget
//
//  Created by makar on 2/19/23.
//

import SwiftUI

struct PersonCellView: View {

  @State private var person: Person

  var name: String {
    person.name ?? "un-named"
  }

  var dateOfBirth: String {
    guard let dateOfBirth = person.dateOfBirth else { fatalError(#function) }

    return dateOfBirth.formatted(.dateTime.year().month().day())
  }

  init(_ person: Person) {
    self.person = person
  }

  var body: some View {
    HStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 0) {
        Text(name)
          .fontWeight(.bold)
          .foregroundColor(.Theme.text)

        Text(dateOfBirth)
          .foregroundColor(.Theme.text.dark(0.5))
          .fontWeight(.medium)
      }

      Spacer()
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 8)
    .padding(.horizontal, 16)
    .cornerRadius(6)
    .overlay(alignment: .bottom) {
      Divider()
        .background(Color.Theme.text.dark(10))
    }
    .padding()
  }
}

struct PersonCellView_Previews: PreviewProvider {
  static var previews: some View {
    let personMock: Person = {
      let person = Person(context: PersistentContainerProvider.shared.viewContext)
      person.name = "Andrew"
      person.personDescription = "Friend"
      person.dateOfBirth = Date()

      return person
    }()

    PersonCellView(personMock)
      .environment(\.locale, Locale(identifier: "ru"))
  }
}
