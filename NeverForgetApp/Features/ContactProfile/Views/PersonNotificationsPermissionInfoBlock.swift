//
//  ContactNotificationsPermissionInfoBlockView.swift
//  NeverForgetApp
//
//  Created by makar on 5/7/23.
//

import SwiftUI

struct ContactNotificationsPermissionInfoBlockView: View {

  @StateObject var viewModel: ContactNotificationsPermissionInfoBlockViewModel

  init(person: Binding<Person>) {
    _viewModel = StateObject(wrappedValue: ContactNotificationsPermissionInfoBlockViewModel(person: person))
  }

  var body: some View {
    HStack(alignment: .firstTextBaseline) {
      Circle()
        .frame(width: 12, height: 12)
        .foregroundColor(Color.Theme.accentColor)

      Text(viewModel.message)
        .foregroundColor(Color.Theme.text3)

      Spacer()
    }
    .padding()
    .overlay {
      RoundedRectangle(cornerRadius: 8)
        .strokeBorder(Color.Theme.accentColor, lineWidth: 1)
    }
    .onChange(of: viewModel.person.isNotificationsEnabled, perform: { _ in
      Task {
        await viewModel.checkIsBlockHidden()
      }
    })
    .task {
      await viewModel.checkIsBlockHidden()
    }
    .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification), perform: { _ in
      Task {
        await viewModel.checkIsBlockHidden()
      }
    })
    .opacity(viewModel.isBlockHidden ? 0 : 1)
    .animation(.easeInOut(duration: 0.3), value: viewModel.isBlockHidden)
  }
}

struct PersonNotificationsPermissionInfoBlock_Previews: PreviewProvider {
  private static let person: Person = {
    let person = Person(context: CoreDataWrapper.shared.viewContext)
    person.name = "Test person"
    person.isNotificationsEnabled = true

    return person
  }()

  static var previews: some View {
    ContactNotificationsPermissionInfoBlockView(person: .constant(person))
  }
}
