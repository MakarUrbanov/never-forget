//
//  PersonCellView.swift
//  never-forget
//
//  Created by makar on 2/19/23.
//

import SwiftUI

struct PersonCellView: View {

  @ObservedObject private var person: Person

  var name: String { person.name ?? "un-named" }
  var defaultImage: some View { Image(systemName: "person").resizable().padding(10) }
  var userImage: UIImage? { person.getDecodedPhoto() }
  var personImageData: Data? { person.photo }
  var dateOfBirth: String {
    guard let dateOfBirth = person.dateOfBirth else { return "" }
    return dateOfBirth.formatted(.dateTime.year().month().day())
  }

  init(_ person: Person) {
    self.person = person
  }

  var body: some View {
    HStack(spacing: 20) {
      DecodedImageWithPlaceholder(data: personImageData,
                                  placeholder: defaultImage,
                                  frame: CGSize(width: 40, height: 40))
        .scaledToFill()
        .frame(maxWidth: 40, maxHeight: 40)
        .cornerRadius(40)

      VStack(alignment: .leading, spacing: 0) {
        Text(name)
          .font(.title3.weight(.bold))
          .foregroundColor(.Theme.text)

        Text(dateOfBirth)
          .font(.subheadline.weight(.medium))
          .foregroundColor(.Theme.text3)
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
