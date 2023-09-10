//
//  ContactsListWelcomeMessageView.swift
//  NeverForgetApp
//
//  Created by makar on 4/30/23.
//

import SwiftUI

struct ContactsListWelcomeMessageView: View {
  var body: some View {
    GeometryReader { geometryProxy in
      VStack(alignment: .center) {
        Text("Add your first contact") // TODO: translate
          .font(.title2.weight(.heavy))
          .foregroundColor(Color(.text))

        Image(systemName: "birthday.cake")
          .resizable()
          .frame(width: geometryProxy.size.width * 0.15, height: geometryProxy.size.width * 0.15)
          .foregroundColor(Color(.background3))
      }
      .offset(y: -(geometryProxy.size.height * 0.2))
      .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}

struct PeopleListCreateMessage_Previews: PreviewProvider {
  static var previews: some View {
    ContactsListWelcomeMessageView()
  }
}
