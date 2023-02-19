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

  init(_ person: Person) {
    self.person = person
  }

  var body: some View {
    HStack(spacing: 0) {
      Text(Localizable.name)
      Text(":")
      Text(name)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical)
    .background(.red)
    .cornerRadius(6)
    .padding()
  }
}

struct PersonCellView_Previews: PreviewProvider {
  static var previews: some View {
    let personMock: Person = {
      let person = Person(context: ListTabContainerProvider.shared.viewContext)
      person.name = "Andrew"
      person.personDescription = "Friend"
      person.dateOfBirth = Date.distantPast

      return person
    }()

    PersonCellView(personMock)
      .environment(\.locale, Locale(identifier: "ru"))
  }
}
