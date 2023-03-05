//
//  PersonRowView.swift
//  never-forget
//
//  Created by makar on 2/19/23.
//

import SwiftUI

struct PersonRowView: View {

  @EnvironmentObject var coordinator: PeopleListCoordinator
  @ObservedObject private var person: Person
  @StateObject var viewModel = PersonRowViewModel()

  var name: String { person.name ?? "un-named" }
  var defaultImage: some View { Image(systemName: "person").resizable().padding(10) }
  var userImage: UIImage? { person.getDecodedPhoto() }
  var dateOfBirth: String {
    guard let dateOfBirth = person.dateOfBirth else { return "" }
    return dateOfBirth.formatted(.dateTime.year().month().day())
  }

  var personImageData: Binding<Data?> {
    Binding(get: {
      person.photo
    }, set: { newValue in
      person.photo = newValue
    })
  }

  init(_ person: Person) {
    self.person = person
  }

  var body: some View {
    Button {
      viewModel.openPersonProfile(coordinator: coordinator, person: person)
    } label: {
      HStack(spacing: 20) {
        DecodedImageWithPlaceholder(data: personImageData,
                                    placeholder: defaultImage,
                                    frame: CGSize(width: 40, height: 40))
          .scaledToFill()
          .frame(maxWidth: 40, maxHeight: 40)
          .mask(Circle())

        VStack(alignment: .leading, spacing: 0) {
          Text(name)
            .font(.title3.weight(.bold))
            .foregroundColor(.Theme.text)
            .lineLimit(2)

          Text(dateOfBirth)
            .font(.subheadline.weight(.medium))
            .foregroundColor(.Theme.text3)
            .lineLimit(1)
        }

        Spacer()
      }
    }
    .buttonStyle(TouchableOpacityButtonStyle())

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

    PersonRowView(personMock)
      .environment(\.locale, Locale(identifier: "ru"))
  }
}
