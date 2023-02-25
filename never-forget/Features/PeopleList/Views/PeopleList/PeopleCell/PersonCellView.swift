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
    guard let dateOfBirth = person.dateOfBirth else { return "" }
    return dateOfBirth.formatted(.dateTime.year().month().day())
  }

  var defaultImage: Image {
    Image(systemName: "person")
  }

  var userImage: UIImage? {
    person.getDecodedPhoto()
  }

  init(_ person: Person) {
    self.person = person
  }

  var body: some View {
    HStack(spacing: 20) {
      if let userImage {
        Image(uiImage: userImage)
          .resizable()
          .frame(maxWidth: 40, maxHeight: 40)
          .scaledToFit()
          .cornerRadius(40)
      } else {
        defaultImage
          .resizable()
          .padding(10)
          .frame(maxWidth: 40, maxHeight: 40)
          .scaledToFit()
          .cornerRadius(40)
      }

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
