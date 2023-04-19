//
//  PersonRowView.swift
//  never-forget
//
//  Created by makar on 2/19/23.
//

import SwiftUI

struct PersonRowView: View {

  @StateObject var viewModel: PersonRowViewModel

  var name: String { viewModel.person.name ?? "un-named" }
  var defaultImage: some View { Image(systemName: "person").resizable().padding(10) }
  var userImage: UIImage? { viewModel.person.getDecodedPhoto() }
  var dateOfBirth: String {
    guard let dateOfBirth = viewModel.person.dateOfBirth else { return "" }
    return dateOfBirth.formatted(.dateTime.year().month().day())
  }

  var personImageData: Binding<Data?> {
    Binding(get: {
      viewModel.person.photo
    }, set: { newValue in
      viewModel.person.photo = newValue
    })
  }

  init(_ person: Person, openPersonProfile: @escaping (Person) -> Void) {
    _viewModel = StateObject(wrappedValue: PersonRowViewModel(person: person, openPersonProfile: openPersonProfile))
  }

  var body: some View {
    Button {
      viewModel.openPersonProfileHandler()
    } label: {
      HStack(spacing: 20) {
        DecodedImageWithPlaceholderView(
          data: personImageData,
          placeholder: defaultImage,
          frame: CGSize(width: 40, height: 40)
        )
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
      .background(Color.Theme.background)
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

    PersonRowView(personMock, openPersonProfile: { _ in })
  }
}
