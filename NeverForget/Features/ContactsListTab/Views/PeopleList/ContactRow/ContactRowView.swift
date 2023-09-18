//
//  ContactRowView.swift
//  never-forget
//
//  Created by makar on 2/19/23.
//

import SwiftUI

struct ContactRowView: View {

  @StateObject var viewModel: PersonRowViewModel

  private var name: String { viewModel.person.name }
  private var defaultImage: some View { Image(systemName: "person").resizable().padding(10) }
  private var dateFormat: String
  private var dateOfBirth: String {
    let dateOfBirth = viewModel.person.dateOfBirth
    return DateFormatter(dateFormat: dateFormat).string(from: dateOfBirth)
  }

  init(_ person: Person, dateFormat: String = "dd MMMM yyyy", openPersonProfile: @escaping (Person) -> Void) {
    _viewModel = StateObject(wrappedValue: PersonRowViewModel(person: person, openPersonProfile: openPersonProfile))
    self.dateFormat = dateFormat
  }

  var body: some View {
    Button {
      viewModel.openPersonProfileHandler()
    } label: {

      HStack(spacing: 20) {
        DecodedImageWithPlaceholderView(
          imageData: viewModel.person.photo,
          placeholder: defaultImage,
          frame: CGSize(width: 40, height: 40)
        )
        .scaledToFill()
        .frame(maxWidth: 40, maxHeight: 40)
        .mask(Circle())

        VStack(alignment: .leading, spacing: 0) {
          Text(name)
            .font(.title3.weight(.bold))
            .foregroundColor(Color(.text))
            .lineLimit(2)

          Text(dateOfBirth)
            .font(.subheadline.weight(.medium))
            .foregroundColor(Color(.text3))
            .lineLimit(1)
        }

        Spacer()
      }
      .contentShape(Rectangle())

    }
    .buttonStyle(TouchableOpacityButtonStyle())
  }
}

struct PersonCellView_Previews: PreviewProvider {
  static var previews: some View {
    let personMock: Person = {
      let person = Person(context: CoreDataStack.shared.viewContext)
      person.name = "Andrew"
      person.personDescription = "Friend"
      person.dateOfBirth = Date()

      return person
    }()

    ContactRowView(personMock, openPersonProfile: { _ in })
  }
}
