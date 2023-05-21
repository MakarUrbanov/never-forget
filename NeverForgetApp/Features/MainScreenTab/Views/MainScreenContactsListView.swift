//
//  MainScreenContactsListView.swift
//  NeverForgetApp
//
//  Created by makar on 3/29/23.
//

import SwiftUI

struct MainScreenContactsListView: View {

  @EnvironmentObject var coordinator: MainScreenCoordinator
  private let peopleSections: [PeopleListSectioned]

  init(peopleSections: [PeopleListSectioned]) {
    self.peopleSections = peopleSections
  }

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 20) {
        ForEach(peopleSections) { peopleSection in
          MainScreenPeopleSectionView(section: peopleSection, goToPersonProfile: coordinator.goToPersonProfile(person:))

          Divider()
            .background(Color.Theme.text4)
        }
      }
    }
  }
}


struct MainScreenPeopleList_Previews: PreviewProvider {
  static var previews: some View {
    MainScreenContactsListView(peopleSections: [])
  }
}
