//
//  MainScreenPeopleSection.swift
//  NeverForgetApp
//
//  Created by makar on 4/3/23.
//

import SwiftUI

struct MainScreenPeopleSection: View {
  let section: PeopleListSectioned
  let goToPersonProfile: (Person) -> Void

  var body: some View {
    LazyVStack(pinnedViews: .sectionHeaders) {
      Section {
        ForEach(section.persons) { people in
          PersonRowView(people, openPersonProfile: goToPersonProfile)
        }
      } header: {
        Text(section.title)
          .font(.headline)
          .opacity(0.5)
          .fontWeight(.semibold)
          .frame(maxWidth: .infinity, alignment: .leading)
          .background(Color.Theme.background)
      }
    }
  }
}

struct MainScreenPeopleSection_Previews: PreviewProvider {
  static let section = PeopleListSectioned(title: "Today:", month: 5, persons: [])

  static var previews: some View {
    MainScreenPeopleSection(section: section, goToPersonProfile: { _ in })
  }
}
